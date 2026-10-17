"""Planova AI mobile shell. Frontend only — no walkers or mock AI."""

import from "@jac/mobui" { View }
import from store {
    Task, StudySession, add_task, delete_task, generate_study_plan, list_sessions,
    list_tasks, replan_missed_sessions, set_session_status, set_task_status,
    task_priority, task_title, unique_session_dates, update_task
}
import from .theme { styles }
import from .components.BottomNav { BottomNav }
import from .screens.Welcome { WelcomeScreen }
import from .screens.Dashboard { DashboardScreen }
import from .screens.Tasks { TasksScreen }
import from .screens.Planner { PlannerScreen }
import from .screens.Schedule { ScheduleScreen }

def:pub app -> JsxElement {
    has screen: str = "welcome";
    has tasks: list[Task] = [];
    has sessions: list[StudySession] = [];
    has dash_message: str = "";
    has task_message: str = "";
    has plan_message: str = "";
    has sched_message: str = "";
    has title: str = "";
    has description: str = "";
    has deadline: str = "";
    has priority: str = "Medium";
    has hours_text: str = "1";
    has editing_id: str = "";
    has study_prompt: str = "";
    has plan_hours: str = "3";
    has generating: bool = False;
    has plan_sessions: list[StudySession] = [];
    has plan_titles: list[str] = [];
    has plan_priorities: list[str] = [];
    has replanning: bool = False;

    def go(name: str) {
        screen = name;
        if name == "dashboard" or name == "tasks" {
            refresh_tasks();
        }
        if name == "schedule" {
            refresh_schedule();
        }
    }

    def refresh_tasks {
        result = list_tasks();
        if result.connected {
            tasks = result.items;
            dash_message = "";
            task_message = "";
        } else {
            tasks = [];
            dash_message = result.message;
            task_message = result.message;
        }
    }

    def refresh_schedule {
        refresh_tasks();
        result = list_sessions();
        if result.connected {
            sessions = result.items;
            sched_message = "";
        } else {
            sessions = [];
            sched_message = result.message;
        }
    }

    def clear_form {
        editing_id = "";
        title = "";
        description = "";
        deadline = "";
        priority = "Medium";
        hours_text = "1";
    }

    def save_task {
        if not title {
            task_message = "Enter a task title.";
            return;
        }
        hours = float(hours_text) if hours_text else 1.0;
        if editing_id {
            current_status = "pending";
            for t in tasks {
                if t.id == editing_id {
                    current_status = t.status;
                }
            }
            result = update_task(Task(
                id=editing_id,
                title=title,
                description=description,
                deadline=deadline,
                priority=priority,
                status=current_status,
                estimated_hours=hours
            ));
            if not result.connected {
                task_message = result.message;
                return;
            }
        } else {
            result = add_task(title, description, deadline, priority, hours);
            if not result.connected {
                task_message = result.message;
                return;
            }
        }
        clear_form();
        refresh_tasks();
    }

    def edit_task(task_id: str) {
        for t in tasks {
            if t.id == task_id {
                editing_id = t.id;
                title = t.title;
                description = t.description;
                deadline = t.deadline;
                priority = t.priority;
                hours_text = str(t.estimated_hours);
            }
        }
    }

    def remove_task(task_id: str) {
        result = delete_task(task_id);
        if not result.connected {
            task_message = result.message;
            return;
        }
        if editing_id == task_id {
            clear_form();
        }
        refresh_tasks();
    }

    def toggle_task(task_id: str) {
        current = "pending";
        for t in tasks {
            if t.id == task_id {
                current = t.status;
            }
        }
        next_status = "pending" if current == "completed" else "completed";
        result = set_task_status(task_id, next_status);
        if not result.connected {
            task_message = result.message;
            return;
        }
        refresh_tasks();
    }

    def generate {
        if generating {
            return;
        }
        if not study_prompt {
            plan_message = "Please describe the study plan you want.";
            return;
        }
        if not plan_hours {
            plan_message = "Enter your available study hours per day.";
            return;
        }
        generating = True;
        plan_message = "";
        plan_sessions = [];
        result = generate_study_plan(study_prompt, float(plan_hours));
        generating = False;
        if result.connected {
            plan_sessions = result.items;
            labels: list[str] = [];
            pris: list[str] = [];
            for s in plan_sessions {
                labels = labels + [task_title(tasks, s.task_id)];
                pris = pris + [task_priority(tasks, s.task_id)];
            }
            plan_titles = labels;
            plan_priorities = pris;
        } else {
            plan_sessions = [];
            plan_message = "Unable to generate your plan right now. Please try again.";
        }
    }

    def complete_session(session_id: str) {
        current = "pending";
        for s in sessions {
            if s.id == session_id {
                current = s.status;
            }
        }
        next_status = "pending" if current == "completed" else "completed";
        result = set_session_status(session_id, next_status);
        if not result.connected {
            sched_message = result.message;
            return;
        }
        refresh_schedule();
    }

    def replan {
        if replanning {
            return;
        }
        replanning = True;
        result = replan_missed_sessions();
        replanning = False;
        if result.connected {
            sessions = result.items;
            sched_message = "";
            refresh_schedule();
        } else {
            sched_message = result.message;
        }
    }

    dates = unique_session_dates(sessions);

    <View style={styles.screen}>
        {if screen == "welcome" {
            <WelcomeScreen onStart={lambda { go("dashboard"); }} />
        }}
        {if screen == "dashboard" {
            <DashboardScreen tasks={tasks} message={dash_message} />
        }}
        {if screen == "tasks" {
            <TasksScreen
                tasks={tasks}
                title={title}
                description={description}
                deadline={deadline}
                priority={priority}
                hours_text={hours_text}
                editing={editing_id != ""}
                message={task_message}
                onTitle={lambda (t: str) { title = t; }}
                onDescription={lambda (t: str) { description = t; }}
                onDeadline={lambda (t: str) { deadline = t; }}
                onPriority={lambda (t: str) { priority = t; }}
                onHours={lambda (t: str) { hours_text = t; }}
                onSave={save_task}
                onEdit={edit_task}
                onDelete={remove_task}
                onToggle={toggle_task}
            />
        }}
        {if screen == "planner" {
            <PlannerScreen
                study_prompt={study_prompt}
                hours_text={plan_hours}
                generating={generating}
                sessions={plan_sessions}
                titles={plan_titles}
                priorities={plan_priorities}
                message={plan_message}
                onPrompt={lambda (t: str) { study_prompt = t; }}
                onHours={lambda (t: str) { plan_hours = t; }}
                onGenerate={generate}
            />
        }}
        {if screen == "schedule" {
            <ScheduleScreen
                dates={dates}
                sessions={sessions}
                tasks={tasks}
                replanning={replanning}
                message={sched_message}
                onComplete={complete_session}
                onReplan={replan}
            />
        }}
        {if screen != "welcome" {
            <BottomNav current={screen} onChange={go} />
        }}
    </View>
}
