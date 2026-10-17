"""AI Study Planner page. Sends a student prompt and study hours to the backend planner."""

import from ..store {
    StudySession, Task, create_study_plan, fetch_tasks, task_priority, task_title
}
import from .AppShell { AppShell }

def:pub PlanRow(session: StudySession, title: str, priority: str) -> JsxElement {
    pri_cls = "priority " + priority.lower();

    <li className="plan-row">
        <span className="plan-meta">
            <span className="plan-label">Subject</span>
            <span className="task-name">{title}</span>
        </span>
        <span className="plan-meta">
            <span className="plan-label">Date</span>
            <span className="task-deadline">{session.date}</span>
        </span>
        <span className="plan-meta">
            <span className="plan-label">Time</span>
            <span className="task-deadline">{session.start_time}</span>
        </span>
        <span className="plan-meta">
            <span className="plan-label">Duration</span>
            <span className="task-deadline">{session.duration_minutes} min</span>
        </span>
        <span className="plan-meta">
            <span className="plan-label">Priority</span>
            <span className={pri_cls}>{priority}</span>
        </span>
    </li>
}

def:pub StudyPlanner -> JsxElement {
    has study_prompt: str = "";
    has hours_text: str = "3";
    has generating: bool = False;
    has generated: bool = False;
    has rationale: str = "";
    has sessions: list[StudySession] = [];
    has tasks: list[Task] = [];
    has error: str = "";

    async can with entry {
        task_result = await fetch_tasks();
        if task_result.connected {
            tasks = task_result.items;
        }
    }

    async def generate {
        if generating {
            return;
        }
        if not study_prompt {
            error = "Please describe the study plan you want.";
            return;
        }
        if not hours_text {
            error = "Enter your available study hours per day.";
            return;
        }
        generating = True;
        generated = False;
        error = "";
        rationale = "";
        sessions = [];
        hours = float(hours_text);
        result = await create_study_plan(study_prompt, hours);
        generating = False;
        if result.connected {
            sessions = result.items;
            rationale = result.message;
            generated = True;
        } else {
            sessions = [];
            generated = False;
            error = result.message;
        }
    }

    <AppShell title="AI Study Planner">
        <section className="dash-welcome">
            <h1>AI Study Planner</h1>
            <p>Describe what you need, add your available hours, and generate a personalized plan.</p>
        </section>
        <section className="panel form-panel">
            <label className="field">
                <span>Available study hours per day</span>
                <input
                    type="number"
                    min="1"
                    max="12"
                    step="0.5"
                    value={hours_text}
                    onChange={lambda (e: ChangeEvent) { hours_text = e.target.value; }}
                />
            </label>
            <label className="field prompt-box">
                <span>What would you like to study?</span>
                <textarea
                    rows={6}
                    value={study_prompt}
                    placeholder="Create a study plan for my upcoming exams. I have Mathematics, Computer Science, and English. I can study 3 hours daily and my exams begin next Monday."
                    onChange={lambda (e: ChangeEvent) { study_prompt = e.target.value; }}
                ></textarea>
            </label>
            <div className="form-actions">
                <button className="btn-primary" type="button" disabled={generating} onClick={generate}>
                    { "Generating..." if generating else "Generate Study Plan" }
                </button>
            </div>
            {if generating {
                <p className="status-loading planner-status">Generating your study plan...</p>
            }}
            {if error {
                <p className="notice error planner-status">{error}</p>
            }}
        </section>
        <section className="panel">
            <h2>Generated study plan</h2>
            {if rationale {
                <p className="planner-status">{rationale}</p>
            }}
            {if not generated and not generating {
                <p className="empty">Your study plan will appear here.</p>
            }}
            {if generated and len(sessions) == 0 {
                <p className="empty">The planner returned no study sessions.</p>
            }}
            <ul className="task-list">
                {for session in sessions {
                    <PlanRow
                        key={session.id}
                        session={session}
                        title={task_title(tasks, session.task_id)}
                        priority={task_priority(tasks, session.task_id)}
                    />
                }}
            </ul>
        </section>
    </AppShell>
}
