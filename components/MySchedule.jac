"""Weekly schedule page. Shows only sessions returned by the backend."""

import from ..store {
    StudySession, Task, fetch_sessions, fetch_tasks, rebuild_missed_sessions,
    change_session_status, task_title, unique_session_dates
}
import from .AppShell { AppShell }

def:pub SessionRow(
    session: StudySession,
    title: str,
    onComplete: Callable[[str], None],
    onMiss: Callable[[str], None]
) -> JsxElement {
    row_cls = "session-row " + session.status;
    action_label = "Undo" if session.status == "completed" else "Mark completed";

    <li className={row_cls}>
        <span className="task-name">{title}</span>
        <span className="task-deadline">{session.start_time} · {session.duration_minutes} min</span>
        <span className={"priority " + session.status}>{session.status}</span>
        <button className="text-btn" type="button" onClick={lambda { onComplete(session.id); }}>
            {action_label}
        </button>
        {if session.status == "pending" {
            <button className="text-btn danger" type="button" onClick={lambda { onMiss(session.id); }}>Mark missed</button>
        }}
    </li>
}

def:pub MySchedule -> JsxElement {
    has sessions: list[StudySession] = [];
    has tasks: list[Task] = [];
    has loading: bool = True;
    has busy: bool = False;
    has replanning: bool = False;
    has error: str = "";

    async can with entry {
        await refresh();
    }

    async def refresh {
        loading = True;
        error = "";
        task_result = await fetch_tasks();
        if task_result.connected {
            tasks = task_result.items;
        }
        result = await fetch_sessions();
        loading = False;
        if result.connected {
            sessions = result.items;
        } else {
            sessions = [];
            error = result.message;
        }
    }

    async def complete_session(session_id: str) {
        if busy {
            return;
        }
        current = "pending";
        for s in sessions {
            if s.id == session_id {
                current = s.status;
            }
        }
        next_status = "pending" if current == "completed" else "completed";
        busy = True;
        error = "";
        result = await change_session_status(session_id, next_status);
        busy = False;
        if not result.connected {
            error = result.message;
            return;
        }
        await refresh();
    }

    async def miss_session(session_id: str) {
        if busy { return; }
        busy = True;
        replanning = True;
        error = "";
        result = await change_session_status(session_id, "missed");
        if not result.connected {
            busy = False;
            replanning = False;
            error = result.message;
            return;
        }
        plan = await rebuild_missed_sessions();
        busy = False;
        replanning = False;
        if plan.connected {
            sessions = plan.items;
        } else {
            error = plan.message;
            await refresh();
        }
    }

    async def replan {
        if busy {
            return;
        }
        busy = True;
        replanning = True;
        error = "";
        result = await rebuild_missed_sessions();
        busy = False;
        replanning = False;
        if result.connected {
            sessions = result.items;
        } else {
            error = result.message;
        }
    }

    dates = unique_session_dates(sessions);

    <AppShell title="My Schedule">
        <section className="dash-welcome">
            <h1>My Schedule</h1>
            <p>Your weekly study sessions, grouped by day.</p>
        </section>
        <div className="form-actions">
            <button className="btn-secondary" type="button" disabled={busy} onClick={replan}>
                { "Replanning..." if replanning else "Replan Missed Sessions" }
            </button>
        </div>
        {if error {
            <p className="notice error">{error}</p>
        }}
        {if loading {
            <p className="status-loading">Loading schedule...</p>
        }}
        {if not loading and len(sessions) == 0 {
            <p className="empty">No study schedule yet</p>
        }}
        <div className="week-grid">
            {for date in dates {
                day_sessions = [s for s in sessions if s.date == date];
                <section key={date} className="panel day-card">
                    <h2>{date}</h2>
                    <ul className="task-list">
                        {for session in day_sessions {
                            <SessionRow
                                key={session.id}
                                session={session}
                                title={task_title(tasks, session.task_id)}
                                onComplete={complete_session}
                                onMiss={miss_session}
                            />
                        }}
                    </ul>
                </section>
            }}
        </div>
    </AppShell>
}
