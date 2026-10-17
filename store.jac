"""Typed client adapter between the Jac UI and server graph walkers."""

import from .backend.api {
    list_tasks as api_list_tasks,
    add_task as api_add_task,
    update_task as api_update_task,
    set_task_status as api_set_task_status,
    delete_task as api_delete_task,
    list_sessions as api_list_sessions,
    set_session_status as api_set_session_status,
    generate_study_plan as api_generate_study_plan,
    replan_missed_sessions as api_replan_missed_sessions
}

obj:pub Task {
    has id: str = "",
        title: str = "",
        description: str = "",
        deadline: str = "",
        priority: str = "Medium",
        status: str = "pending",
        estimated_hours: float = 1.0;
}

obj:pub StudySession {
    has id: str = "",
        task_id: str = "",
        date: str = "",
        start_time: str = "",
        duration_minutes: int = 60,
        status: str = "pending";
}

obj:pub TaskListResult {
    has connected: bool = False,
        message: str = "",
        items: list[Task] = [];
}

obj:pub TaskResult {
    has connected: bool = False,
        message: str = "",
        item: Task = Task();
}

obj:pub SessionListResult {
    has connected: bool = False,
        message: str = "",
        items: list[StudySession] = [];
}

obj:pub SessionResult {
    has connected: bool = False,
        message: str = "",
        item: StudySession = StudySession();
}

obj:pub ActionResult {
    has connected: bool = False,
        message: str = "";
}

glob BACKEND_UNAVAILABLE: str = "Could not reach the Planova backend. Check that the Jac service is running.";

def task_from_report(item: dict) -> Task {
    return Task(id=item["id"], title=item["title"], description=item["description"],
        deadline=item["deadline"], priority=item["priority"], status=item["status"],
        estimated_hours=item["estimated_hours"]);
}

def session_from_report(item: dict) -> StudySession {
    return StudySession(id=item["id"], task_id=item["task_id"], date=item["date"],
        start_time=item["start_time"], duration_minutes=item["duration_minutes"], status=item["status"]);
}

async def:pub fetch_tasks -> TaskListResult {
    try {
        result = root spawn api_list_tasks();
        if result.reports and len(result.reports) > 0 {
            return TaskListResult(connected=True,
                items=[task_from_report(item) for item in result.reports[0]]);
        }
        return TaskListResult(connected=True, items=[]);
    } except Exception as e {
        return TaskListResult(connected=False, message=f"{BACKEND_UNAVAILABLE} {e}");
    }
}

async def:pub create_task(title: str, description: str, deadline: str,
    priority: str, estimated_hours: float) -> TaskResult {
    try {
        result = root spawn api_add_task(title=title, description=description,
            deadline=deadline, priority=priority, estimated_hours=estimated_hours);
        if result.reports and len(result.reports) > 0 {
            item = result.reports[0];
            if item.get("error") { return TaskResult(connected=False, message=item["error"]); }
            return TaskResult(connected=True, item=task_from_report(item));
        }
        return TaskResult(connected=False, message="Task creation returned no result.");
    } except Exception as e {
        return TaskResult(connected=False, message=f"{BACKEND_UNAVAILABLE} {e}");
    }
}

async def:pub update_existing_task(task_id: str, title: str, description: str,
    deadline: str, priority: str, status: str,
    estimated_hours: float) -> TaskResult {
    try {
        result = root spawn api_update_task(id=task_id, title=title,
            description=description, deadline=deadline, priority=priority,
            status=status, estimated_hours=estimated_hours);
        if result.reports and len(result.reports) > 0 {
            item = result.reports[0];
            if item.get("error") { return TaskResult(connected=False, message=item["error"]); }
            return TaskResult(connected=True, item=task_from_report(item));
        }
        return TaskResult(connected=False, message="Task update returned no result.");
    } except Exception as e {
        return TaskResult(connected=False, message=f"{BACKEND_UNAVAILABLE} {e}");
    }
}

async def:pub change_task_status(task_id: str, status: str) -> TaskResult {
    try {
        result = root spawn api_set_task_status(task_id=task_id, status=status);
        if result.reports and len(result.reports) > 0 {
            item = result.reports[0];
            if item.get("error") { return TaskResult(connected=False, message=item["error"]); }
            return TaskResult(connected=True, item=task_from_report(item));
        }
        return TaskResult(connected=False, message="Task update returned no result.");
    } except Exception as e {
        return TaskResult(connected=False, message=f"{BACKEND_UNAVAILABLE} {e}");
    }
}

async def:pub delete_task_api(task_id: str) -> ActionResult {
    try {
        result = root spawn api_delete_task(task_id=task_id);
        if result.reports and len(result.reports) > 0 {
            item = result.reports[0];
            if item.get("error") { return ActionResult(connected=False, message=item["error"]); }
            return ActionResult(connected=True);
        }
        return ActionResult(connected=False, message="Task deletion returned no result.");
    } except Exception as e {
        return ActionResult(connected=False, message=f"{BACKEND_UNAVAILABLE} {e}");
    }
}

async def:pub fetch_sessions -> SessionListResult {
    try {
        result = root spawn api_list_sessions();
        if result.reports and len(result.reports) > 0 {
            return SessionListResult(connected=True,
                items=[session_from_report(item) for item in result.reports[0]]);
        }
        return SessionListResult(connected=True, items=[]);
    } except Exception as e {
        return SessionListResult(connected=False, message=f"{BACKEND_UNAVAILABLE} {e}");
    }
}

async def:pub change_session_status(session_id: str, status: str) -> SessionResult {
    try {
        result = root spawn api_set_session_status(session_id=session_id, status=status);
        if result.reports and len(result.reports) > 0 {
            item = result.reports[0];
            if item.get("error") { return SessionResult(connected=False, message=item["error"]); }
            return SessionResult(connected=True, item=session_from_report(item));
        }
        return SessionResult(connected=False, message="Session update returned no result.");
    } except Exception as e {
        return SessionResult(connected=False, message=f"{BACKEND_UNAVAILABLE} {e}");
    }
}

async def:pub create_study_plan(prompt: str, hours_per_day: float) -> SessionListResult {
    try {
        result = root spawn api_generate_study_plan(prompt=prompt, hours_per_day=hours_per_day);
        if result.reports and len(result.reports) > 0 {
            payload = result.reports[0];
            if payload.get("error") { return SessionListResult(connected=False, message=payload["error"]); }
            return SessionListResult(connected=True,
                message=payload["rationale"],
                items=[session_from_report(item) for item in payload["sessions"]]);
        }
        return SessionListResult(connected=False, message="The planner returned no result.");
    } except Exception as e {
        return SessionListResult(connected=False, message=f"{BACKEND_UNAVAILABLE} {e}");
    }
}

async def:pub rebuild_missed_sessions -> SessionListResult {
    try {
        result = root spawn api_replan_missed_sessions();
        if result.reports and len(result.reports) > 0 {
            payload = result.reports[0];
            if payload.get("error") { return SessionListResult(connected=False, message=payload["error"]); }
            latest = root spawn api_list_sessions();
            if latest.reports and len(latest.reports) > 0 {
                return SessionListResult(connected=True,
                    items=[session_from_report(item) for item in latest.reports[0]]);
            }
            return SessionListResult(connected=True,
                items=[session_from_report(item) for item in payload["sessions"]]);
        }
        return SessionListResult(connected=True, items=[]);
    } except Exception as e {
        return SessionListResult(connected=False, message=f"{BACKEND_UNAVAILABLE} {e}");
    }
}

def:pub find_task(tasks: list[Task], task_id: str) -> Task | None {
    for t in tasks { if t.id == task_id { return t; } }
    return None;
}

def:pub task_title(tasks: list[Task], task_id: str) -> str {
    task = find_task(tasks, task_id);
    if task is not None { return task.title; }
    return "Study session";
}

def:pub task_priority(tasks: list[Task], task_id: str) -> str {
    task = find_task(tasks, task_id);
    if task is not None { return task.priority; }
    return "Medium";
}

def:pub unique_session_dates(sessions: list[StudySession]) -> list[str] {
    dates: list[str] = [];
    for s in sessions {
        exists = False;
        for d in dates { if d == s.date { exists = True; } }
        if not exists and s.date { dates = dates + [s.date]; }
    }
    return dates;
}
