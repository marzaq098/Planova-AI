"""Dashboard overview. Statistics come from loaded task data only."""

import from "@jac/runtime" { Link }
import from ..store { Task, fetch_tasks, change_task_status }
import from .AppShell { AppShell }

def:pub DashTaskRow(task: Task, onToggle: Callable[[str], None]) -> JsxElement {
    done = task.status == "completed";
    row_cls = "task-row done" if done else "task-row";
    pri_cls = "priority " + task.priority.lower();

    <li className={row_cls}>
        <label className="task-check">
            <input
                type="checkbox"
                checked={done}
                onChange={lambda { onToggle(task.id); }}
            />
            <span className="task-name">{task.title}</span>
        </label>
        <span className="task-deadline">{task.deadline}</span>
        <span className={pri_cls}>{task.priority}</span>
    </li>
}

def:pub Dashboard -> JsxElement {
    has tasks: list[Task] = [];
    has loading: bool = True;
    has busy: bool = False;
    has error: str = "";

    async can with entry {
        await refresh();
    }

    async def refresh {
        loading = True;
        error = "";
        result = await fetch_tasks();
        loading = False;
        if result.connected {
            tasks = result.items;
        } else {
            tasks = [];
            error = result.message;
        }
    }

    async def toggle_task(task_id: str) {
        if busy {
            return;
        }
        current = "pending";
        for t in tasks {
            if t.id == task_id {
                current = t.status;
            }
        }
        next_status = "pending" if current == "completed" else "completed";
        busy = True;
        error = "";
        result = await change_task_status(task_id, next_status);
        busy = False;
        if not result.connected {
            error = result.message;
            return;
        }
        await refresh();
    }

    total = len(tasks);
    completed = len([t for t in tasks if t.status == "completed"]);
    pending = len([t for t in tasks if t.status != "completed"]);
    upcoming = len([t for t in tasks if t.status != "completed" and t.deadline]);

    <AppShell title="Dashboard">
        <section className="dash-welcome">
            <p className="eyebrow">YOUR PLAN, AT A GLANCE</p>
            <h1>Welcome to the demo workspace</h1>
            <p>Explore tasks, build a study plan, and see how it adapts when a session is missed.</p>
        </section>
        <p className="demo-notice"><span aria-hidden="true">ⓘ</span> This is a shared demo workspace. Changes may be visible to other people using this link. There are no user accounts yet.</p>
        {if error {
            <p className="notice error">{error}</p>
        }}
        {if loading {
            <p className="status-loading">Loading dashboard...</p>
        }}
        <section className="summary-grid" aria-label="Study summary">
            <article className="summary-card">
                <p className="summary-label">Total Tasks</p>
                <p className="summary-value">{total}</p>
            </article>
            <article className="summary-card">
                <p className="summary-label">Completed Tasks</p>
                <p className="summary-value">{completed}</p>
            </article>
            <article className="summary-card">
                <p className="summary-label">Pending Tasks</p>
                <p className="summary-value">{pending}</p>
            </article>
            <article className="summary-card">
                <p className="summary-label">Upcoming Deadlines</p>
                <p className="summary-value">{upcoming}</p>
            </article>
        </section>
        <div className="dash-panels">
            <section className="panel" aria-labelledby="today-tasks-heading">
                <h2 id="today-tasks-heading">Today's Tasks</h2>
                {if not loading and len(tasks) == 0 {
                    <p className="empty">No assignments in the demo yet. Add a task, then visit the planner to build a schedule.</p>
                }}
                <ul className="task-list">
                    {for task in tasks {
                        <DashTaskRow key={task.id} task={task} onToggle={toggle_task} />
                    }}
                </ul>
            </section>
            <section className="panel" aria-labelledby="quick-actions-heading">
                <h2 id="quick-actions-heading">Quick Actions</h2>
                <div className="quick-actions">
                    <Link to="/tasks" className="btn-primary">Add New Task</Link>
                    <Link to="/planner" className="btn-secondary">Generate Study Plan</Link>
                </div>
            </section>
        </div>
    </AppShell>
}
