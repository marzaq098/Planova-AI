"""My Tasks page. Uses backend task APIs when they are available."""

import from ..store {
    Task, create_task, fetch_tasks, delete_task_api, update_existing_task, change_task_status
}
import from .AppShell { AppShell }

def:pub TaskManageRow(
    task: Task,
    onToggle: Callable[[str], None],
    onEdit: Callable[[str], None],
    onDelete: Callable[[str], None]
) -> JsxElement {
    done = task.status == "completed";
    row_cls = "manage-row done" if done else "manage-row";
    pri_cls = "priority " + task.priority.lower();

    <li className={row_cls}>
        <label className="task-check">
            <input
                type="checkbox"
                checked={done}
                onChange={lambda { onToggle(task.id); }}
            />
            <span>
                <span className="task-name">{task.title}</span>
                {if task.description {
                    <span className="task-desc">{task.description}</span>
                }}
            </span>
        </label>
        <span className="task-deadline">{task.deadline}</span>
        <span className={pri_cls}>{task.priority}</span>
        <span className="row-actions">
            <button className="text-btn" type="button" onClick={lambda { onEdit(task.id); }}>Edit</button>
            <button className="text-btn danger" type="button" onClick={lambda { onDelete(task.id); }}>Delete</button>
        </span>
    </li>
}

def:pub MyTasks -> JsxElement {
    has tasks: list[Task] = [];
    has filter: str = "all";
    has editing_id: str = "";
    has title: str = "";
    has description: str = "";
    has deadline: str = "";
    has priority: str = "Medium";
    has hours_text: str = "1";
    has loading: bool = True;
    has busy: bool = False;
    has error: str = "";

    async can with entry {
        await refresh();
    }

    def clear_form {
        editing_id = "";
        title = "";
        description = "";
        deadline = "";
        priority = "Medium";
        hours_text = "1";
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

    def hours_value -> float {
        if not hours_text {
            return 1.0;
        }
        return float(hours_text);
    }

    async def save_task {
        if busy {
            return;
        }
        if not title {
            error = "Enter a task title.";
            return;
        }
        hours = hours_value();
        busy = True;
        error = "";
        if editing_id {
            current_status = "pending";
            for t in tasks {
                if t.id == editing_id {
                    current_status = t.status;
                }
            }
            result = await update_existing_task(editing_id, title, description,
                deadline, priority, current_status, hours);
            busy = False;
            if not result.connected {
                error = result.message;
                return;
            }
        } else {
            result = await create_task(title, description, deadline, priority, hours);
            busy = False;
            if not result.connected {
                error = result.message;
                return;
            }
        }
        clear_form();
        await refresh();
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

    async def remove_task(task_id: str) {
        if busy {
            return;
        }
        busy = True;
        error = "";
        result = await delete_task_api(task_id);
        busy = False;
        if not result.connected {
            error = result.message;
            return;
        }
        if editing_id == task_id {
            clear_form();
        }
        await refresh();
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

    shown: list[Task] = tasks;
    if filter == "pending" {
        shown = [t for t in tasks if t.status == "pending"];
    } elif filter == "completed" {
        shown = [t for t in tasks if t.status == "completed"];
    }
    save_label = "Save Task" if editing_id else "Add Task";
    empty_copy = "No tasks yet. Add your first task.";
    if len(tasks) > 0 {
        empty_copy = "No tasks in this view.";
    }

    <AppShell title="My Tasks">
        <section className="dash-welcome">
            <h1>My Tasks</h1>
            <p>Add, edit, and track your assignments.</p>
        </section>
        {if error {
            <p className="notice error">{error}</p>
        }}
        <section className="panel form-panel">
            <h2>{ "Edit task" if editing_id else "Add a new task" }</h2>
            <div className="form-grid">
                <label className="field">
                    <span>Title</span>
                    <input
                        type="text"
                        value={title}
                        placeholder="Task title"
                        onChange={lambda (e: ChangeEvent) { title = e.target.value; }}
                    />
                </label>
                <label className="field">
                    <span>Deadline</span>
                    <input
                        type="date"
                        value={deadline}
                        onChange={lambda (e: ChangeEvent) { deadline = e.target.value; }}
                    />
                </label>
                <label className="field">
                    <span>Priority</span>
                    <select
                        value={priority}
                        onChange={lambda (e: ChangeEvent) { priority = e.target.value; }}
                    >
                        <option value="High">High</option>
                        <option value="Medium">Medium</option>
                        <option value="Low">Low</option>
                    </select>
                </label>
                <label className="field">
                    <span>Estimated hours</span>
                    <input
                        type="number"
                        min="0.5"
                        step="0.5"
                        value={hours_text}
                        onChange={lambda (e: ChangeEvent) { hours_text = e.target.value; }}
                    />
                </label>
                <label className="field wide">
                    <span>Description</span>
                    <textarea
                        rows={2}
                        value={description}
                        placeholder="Optional details"
                        onChange={lambda (e: ChangeEvent) { description = e.target.value; }}
                    ></textarea>
                </label>
            </div>
            <div className="form-actions">
                <button className="btn-primary" type="button" disabled={busy} onClick={save_task}>{save_label}</button>
                {if editing_id {
                    <button className="btn-secondary" type="button" onClick={clear_form}>Cancel</button>
                }}
            </div>
        </section>
        <section className="panel">
            <div className="panel-head">
                <h2>Task list</h2>
                <div className="filter-bar" role="group" aria-label="Filter tasks">
                    <button className={"chip" + (" active" if filter == "all" else "")} type="button" onClick={lambda { filter = "all"; }}>All</button>
                    <button className={"chip" + (" active" if filter == "pending" else "")} type="button" onClick={lambda { filter = "pending"; }}>Pending</button>
                    <button className={"chip" + (" active" if filter == "completed" else "")} type="button" onClick={lambda { filter = "completed"; }}>Completed</button>
                </div>
            </div>
            {if loading {
                <p className="status-loading">Loading tasks...</p>
            }}
            {if not loading and len(shown) == 0 {
                <p className="empty">{empty_copy}</p>
            }}
            <ul className="task-list">
                {for task in shown {
                    <TaskManageRow
                        key={task.id}
                        task={task}
                        onToggle={toggle_task}
                        onEdit={edit_task}
                        onDelete={remove_task}
                    />
                }}
            </ul>
        </section>
    </AppShell>
}
