"""Frontend API layer for Planova AI.

UI pages must read and write data only through these functions.
This module does not invent HTTP URLs, seed data, or AI results.

BACKEND CONTRACT:
The teammate should expose matching Jac `def:pub` functions or
`walker:pub` walkers using the same names and field types below.
When those endpoints exist, replace each function body with an
awaited server call (function RPC or `root spawn`). Until then,
every call reports that the backend is unavailable and returns
no fabricated items.

Do not add API URLs here until the team agrees on them.
"""

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

glob:pub BACKEND_UNAVAILABLE: str = "Backend is not connected yet. Waiting for the teammate's Jac walker APIs.";

def:pub list_tasks -> TaskListResult {
    # BACKEND: items = await list_tasks();
    #          return TaskListResult(connected=True, items=items);
    return TaskListResult(connected=False, message=BACKEND_UNAVAILABLE, items=[]);
}

def:pub add_task(
    title: str,
    description: str,
    deadline: str,
    priority: str,
    estimated_hours: float
) -> TaskResult {
    # BACKEND: item = await add_task(title, description, deadline, priority, estimated_hours);
    #          return TaskResult(connected=True, item=item);
    return TaskResult(connected=False, message=BACKEND_UNAVAILABLE);
}

def:pub update_task(task: Task) -> TaskResult {
    # BACKEND: item = await update_task(task);
    #          return TaskResult(connected=True, item=item);
    return TaskResult(connected=False, message=BACKEND_UNAVAILABLE);
}

def:pub delete_task(task_id: str) -> ActionResult {
    # BACKEND: await delete_task(task_id);
    #          return ActionResult(connected=True);
    return ActionResult(connected=False, message=BACKEND_UNAVAILABLE);
}

def:pub set_task_status(task_id: str, status: str) -> TaskResult {
    # BACKEND: item = await set_task_status(task_id, status);
    #          return TaskResult(connected=True, item=item);
    return TaskResult(connected=False, message=BACKEND_UNAVAILABLE);
}

def:pub list_sessions -> SessionListResult {
    # BACKEND: items = await list_sessions();
    #          return SessionListResult(connected=True, items=items);
    return SessionListResult(connected=False, message=BACKEND_UNAVAILABLE, items=[]);
}

def:pub set_session_status(session_id: str, status: str) -> SessionResult {
    # BACKEND: item = await set_session_status(session_id, status);
    #          return SessionResult(connected=True, item=item);
    return SessionResult(connected=False, message=BACKEND_UNAVAILABLE);
}

def:pub generate_study_plan(prompt: str, hours_per_day: float) -> SessionListResult {
    # BACKEND: items = await generate_study_plan(prompt, hours_per_day);
    #          return SessionListResult(connected=True, items=items);
    return SessionListResult(connected=False, message="", items=[]);
}

def:pub replan_missed_sessions -> SessionListResult {
    # BACKEND: items = await replan_missed_sessions();
    #          return SessionListResult(connected=True, items=items);
    return SessionListResult(connected=False, message=BACKEND_UNAVAILABLE, items=[]);
}

def:pub find_task(tasks: list[Task], task_id: str) -> Task | None {
    for t in tasks {
        if t.id == task_id {
            return t;
        }
    }
    return None;
}

def:pub task_title(tasks: list[Task], task_id: str) -> str {
    task = find_task(tasks, task_id);
    if task is not None {
        return task.title;
    }
    return "Study session";
}

def:pub task_priority(tasks: list[Task], task_id: str) -> str {
    task = find_task(tasks, task_id);
    if task is not None {
        return task.priority;
    }
    return "Medium";
}

def:pub unique_session_dates(sessions: list[StudySession]) -> list[str] {
    dates: list[str] = [];
    for s in sessions {
        exists = False;
        for d in dates {
            if d == s.date {
                exists = True;
            }
        }
        if not exists {
            if s.date {
                dates = dates + [s.date];
            }
        }
    }
    return dates;
}
