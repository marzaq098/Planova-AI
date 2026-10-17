"""Graph-backed task, schedule, and adaptive planning API."""
import from datetime { datetime, date }
import os;
# Persisted graph entities. Jac's service runtime persists graph state to SQLite.
node Task {
    has title: str;
    has deadline: str;
    has created_at: str;
    has description: str = "";
    has priority: str = "Medium";
    has status: str = "pending";
    has estimated_hours: float = 1.0;
}

node StudySession {
    has task_id: str;
    has task_title: str;
    has date: str;
    has start_time: str;
    has duration_minutes: int;
    has daily_limit_minutes: int = 180;
    has status: str = "pending";
}

edge StudySessionForTask { }

def task_sort_key(task: Task) -> tuple[bool, str, int] {
    priority_rank = 0 if task.priority == "High" else (1 if task.priority == "Medium" else 2);
    return (task.deadline == "", task.deadline, priority_rank);
}

def plan_rationale(prompt: str, tasks: list[dict], sessions: list[dict]) -> str by llm();

walker:pub health {
    can check with Root entry {
        report {"status": "ok", "service": "planova-ai"};
    }
}

walker:pub list_tasks {
    can fetch with Root entry {
        report [{"id": jid(t), "title": t.title, "description": t.description,
            "deadline": t.deadline, "priority": t.priority, "status": t.status,
            "estimated_hours": t.estimated_hours}
            for t in [-->][?:Task]];
    }
}

walker:pub add_task {
    has title: str;
    has deadline: str;
    has description: str = "";
    has priority: str = "Medium";
    has estimated_hours: float = 1.0;

    can create with Root entry {
        if self.title.strip() == "" { report {"error": "Enter a task title."}; return; }
        if self.estimated_hours <= 0 { report {"error": "Estimated hours must be greater than zero."}; return; }
        if self.priority not in ["High", "Medium", "Low"] { report {"error": "Priority must be High, Medium, or Low."}; return; }
        if self.deadline != "" {
            try { date.fromisoformat(self.deadline); }
            except Exception { report {"error": "Deadline must use YYYY-MM-DD format."}; return; }
        }
        task = Task(title=self.title.strip(), description=self.description,
            deadline=self.deadline, priority=self.priority,
            estimated_hours=self.estimated_hours, created_at=datetime.now().isoformat());
        root ++> task;
        report {"id": jid(task), "title": task.title, "description": task.description,
            "deadline": task.deadline, "priority": task.priority,
            "status": task.status, "estimated_hours": task.estimated_hours};
    }
}

walker:pub update_task {
    has id: str;
    has title: str = "";
    has description: str = "";
    has deadline: str = "";
    has priority: str = "";
    has status: str = "";
    has estimated_hours: float = 0.0;

    can update with Root entry {
        if self.deadline != "" {
            try { date.fromisoformat(self.deadline); }
            except Exception { report {"error": "Deadline must use YYYY-MM-DD format."}; return; }
        }
        for task in [-->][?:Task] {
            if jid(task) == self.id {
                if self.title != "" { task.title = self.title.strip(); }
                if self.description != "" { task.description = self.description; }
                if self.deadline != "" { task.deadline = self.deadline; }
                if self.estimated_hours > 0 { task.estimated_hours = self.estimated_hours; }
                if self.priority != "" {
                    if self.priority not in ["High", "Medium", "Low"] { report {"error": "Priority must be High, Medium, or Low."}; return; }
                    task.priority = self.priority;
                }
                if self.status != "" {
                    if self.status not in ["pending", "completed", "missed"] { report {"error": "Invalid task status."}; return; }
                    task.status = self.status;
                }
                report {"id": jid(task), "title": task.title, "description": task.description,
                    "deadline": task.deadline, "priority": task.priority,
                    "status": task.status, "estimated_hours": task.estimated_hours};
                return;
            }
        }
        report {"error": "Task not found."};
    }
}

walker:pub set_task_status {
    has task_id: str;
    has status: str;
    can update with Root entry {
        if self.status not in ["pending", "completed"] { report {"error": "Status must be pending or completed."}; return; }
        for task in [-->][?:Task] {
            if jid(task) == self.task_id {
                task.status = self.status;
                if self.status == "completed" {
                    for session in [-->][?:StudySession] {
                        if session.task_id == self.task_id and session.status == "pending" { session.status = "completed"; }
                    }
                }
                report {"id": jid(task), "title": task.title, "description": task.description,
                    "deadline": task.deadline, "priority": task.priority,
                    "status": task.status, "estimated_hours": task.estimated_hours};
                return;
            }
        }
        report {"error": "Task not found."};
    }
}

walker:pub delete_task {
    has task_id: str;
    can remove with Root entry {
        for task in [-->][?:Task] {
            if jid(task) == self.task_id {
                for session in [-->][?:StudySession] {
                    if session.task_id == self.task_id { del session; }
                }
                del task;
                report {"success": True};
                return;
            }
        }
        report {"error": "Task not found."};
    }
}

walker:pub list_sessions {
    can fetch with Root entry {
        report [{"id": jid(s), "task_id": s.task_id, "date": s.date,
            "start_time": s.start_time, "duration_minutes": s.duration_minutes,
            "status": s.status}
            for s in [-->][?:StudySession]];
    }
}

walker:pub set_session_status {
    has session_id: str;
    has status: str;
    can update with Root entry {
        if self.status not in ["pending", "completed", "missed"] { report {"error": "Invalid session status."}; return; }
        for session in [-->][?:StudySession] {
            if jid(session) == self.session_id {
                session.status = self.status;
                report {"id": jid(session), "task_id": session.task_id,
                    "date": session.date, "start_time": session.start_time,
                    "duration_minutes": session.duration_minutes, "status": session.status};
                return;
            }
        }
        report {"error": "Study session not found."};
    }
}

# This planner is intentionally deterministic for scheduling: Claude can explain
# the validated result, but cannot alter dates, task identities, or total hours.
walker:pub generate_study_plan {
    has prompt: str;
    has hours_per_day: float;

    can plan with Root entry {
        if self.hours_per_day <= 0 { report {"error": "Available study hours must be greater than zero."}; return; }
        tasks = [t for t in [-->][?:Task] if t.status != "completed"];
        if len(tasks) == 0 {
            report {"sessions": [], "rationale": "Add tasks to generate a study schedule.",
                "available_hours": self.hours_per_day, "scheduled_minutes": 0};
            return;
        }
        for old_session in [-->][?:StudySession] {
            if old_session.date == date.today().isoformat() and old_session.status == "pending" { del old_session; }
        }
        ordered = sorted(tasks, key=task_sort_key);
        today = date.today();
        remaining = self.hours_per_day;
        completed_today = sum([s.duration_minutes for s in [-->][?:StudySession]
            if s.date == today.isoformat() and s.status == "completed"]) / 60.0;
        latest_completed_end = 9 * 60;
        for previous in [-->][?:StudySession] {
            if previous.date == today.isoformat() and previous.status == "completed" {
                parts = previous.start_time.split(":");
                end_time = int(parts[0]) * 60 + int(parts[1]) + previous.duration_minutes;
                latest_completed_end = max(latest_completed_end, end_time);
            }
        }
        remaining -= completed_today;
        if remaining < 0 { remaining = 0.0; }
        clock_minutes = latest_completed_end;
        created = [];
        plan_data = [];
        for task in ordered {
            if remaining <= 0 { break; }
            completed_for_task = sum([s.duration_minutes for s in [-->][?:StudySession]
                if s.task_id == jid(task) and s.status == "completed"]) / 60.0;
            task_remaining = max(0.0, task.estimated_hours - completed_for_task);
            task_hours = min(task_remaining, remaining);
            minutes = int(task_hours * 60);
            if minutes > 0 {
                start_hour = int(clock_minutes / 60);
                start_minute = clock_minutes % 60;
                session = StudySession(task_id=jid(task), task_title=task.title,
                    date=today.isoformat(), start_time=f"{start_hour:02d}:{start_minute:02d}",
                    duration_minutes=minutes, daily_limit_minutes=int(self.hours_per_day * 60), status="pending");
                root ++> session;
                task +>: StudySessionForTask :+> session;
                created.append({"id": jid(session), "task_id": session.task_id,
                    "date": session.date, "start_time": session.start_time,
                    "duration_minutes": session.duration_minutes, "status": session.status});
                plan_data.append({"title": task.title, "deadline": task.deadline,
                    "priority": task.priority, "minutes": minutes});
                remaining -= task_hours;
                clock_minutes += minutes;
            }
        }
        rationale = "Schedule ordered by deadline and priority; total time stays within your daily limit.";
        if os.getenv("ANTHROPIC_API_KEY", "") != "" {
            try { rationale = plan_rationale(self.prompt, plan_data, created); }
            except Exception { rationale = "Schedule generated with deadline and priority ordering; AI explanation is unavailable."; }
        }
        report {"sessions": created, "rationale": rationale,
            "available_hours": self.hours_per_day,
            "scheduled_minutes": sum([item["duration_minutes"] for item in created])};
    }
}

walker:pub replan_missed_sessions {
    can replan with Root entry {
        today = date.today();
        limit_minutes = 0;
        completed_minutes = 0;
        latest_completed_end = 9 * 60;
        has_missed = False;
        for session in [-->][?:StudySession] {
            if session.date == today.isoformat() {
                limit_minutes = max(limit_minutes, session.daily_limit_minutes);
                if session.status == "completed" {
                    completed_minutes += session.duration_minutes;
                    parts = session.start_time.split(":");
                    end_time = int(parts[0]) * 60 + int(parts[1]) + session.duration_minutes;
                    latest_completed_end = max(latest_completed_end, end_time);
                }
                if session.status == "missed" { has_missed = True; }
            }
        }
        if not has_missed { report {"error": "Mark a session as missed before replanning."}; return; }
        remaining_minutes = max(0, limit_minutes - completed_minutes);
        for session in [-->][?:StudySession] {
            if session.date == today.isoformat() and session.status == "pending" { del session; }
        }
        if remaining_minutes <= 0 { report {"sessions": []}; return; }
        # Rebuild uncompleted work within the original plan's remaining daily cap.
        tasks = [t for t in [-->][?:Task] if t.status != "completed"];
        ordered = sorted(tasks, key=task_sort_key);
        remaining = remaining_minutes / 60.0;
        clock_minutes = latest_completed_end;
        rebuilt = [];
        for task in ordered {
            if remaining <= 0 { break; }
            completed_for_task = sum([s.duration_minutes for s in [-->][?:StudySession]
                if s.task_id == jid(task) and s.status == "completed"]) / 60.0;
            task_remaining = max(0.0, task.estimated_hours - completed_for_task);
            task_hours = min(task_remaining, remaining);
            minutes = int(task_hours * 60);
            if minutes > 0 {
                start_hour = int(clock_minutes / 60);
                start_minute = clock_minutes % 60;
                session = StudySession(task_id=jid(task), task_title=task.title,
                    date=today.isoformat(), start_time=f"{start_hour:02d}:{start_minute:02d}",
                    duration_minutes=minutes, daily_limit_minutes=limit_minutes, status="pending");
                root ++> session;
                task +>: StudySessionForTask :+> session;
                rebuilt.append({"id": jid(session), "task_id": session.task_id,
                    "date": session.date, "start_time": session.start_time,
                    "duration_minutes": session.duration_minutes, "status": session.status});
                remaining -= task_hours;
                clock_minutes += minutes;
            }
        }
        report {"sessions": rebuilt};
    }
}
