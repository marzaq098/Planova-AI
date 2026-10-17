# &#x20;Planova AI

### An Adaptive AI Study Agent

**Plan Smarter. Study Better. Achieve More.**

Planova AI is an AI-powered study planning web application designed to help students organize assignments, manage deadlines, create personalized study schedules, and adapt their study plans when unexpected changes occur.

Built with **Jac/Jaseci**, Planova AI aims to move beyond traditional study planners by introducing an intelligent agent that can plan, monitor, and adjust a student's academic schedule.



---

## &#x20;Why Planova AI?

Students often struggle with managing assignments, preparing for exams, and balancing multiple academic responsibilities.

Traditional study planners allow students to create schedules, but when a study session is missed, students must manually reorganize their plans.

**Planova AI aims to solve this through adaptive AI-powered study planning.**

Instead of simply generating a timetable, the system is designed to adjust study schedules based on changing priorities, missed sessions, deadlines, and available study time.

## &#x20;Key Features

### &#x20;Smart Dashboard

- Overview of academic tasks and deadlines.
- Completed and pending task statistics.
- Upcoming deadlines.
- Quick access to study planning.

### &#x20;Task Management

- Add, edit, and delete academic tasks.
- Set assignment deadlines.
- Assign task priorities.
- Mark tasks as completed.
- Filter tasks by status.

### &#x20;AI Study Planner

- Describe study requirements using natural language.
- Specify available study hours per day.
- Request a personalized study schedule.
- View generated study sessions.

**Example prompt:**

> Create a study plan for my upcoming exams in Mathematics, Computer Science, and English. I can study three hours daily, and my exams begin next Monday.



### &#x20;Weekly Study Schedule

- View study sessions throughout the week.
- Track completed and pending sessions.
- Organize academic activities by date and time.

### &#x20;Adaptive Rescheduling

The planned AI agent will:

1. Detect missed or incomplete study sessions.
2. Evaluate remaining tasks and deadlines.
3. Recalculate available study time.
4. Generate an updated study schedule.

This is the core feature that differentiates Planova AI from ordinary timetable applications.



---

## &#x20;Application Screens

| Screen           | Description                     |
| ---------------- | ------------------------------- |
| Splash & Landing | Introduction to Planova AI      |
| Dashboard        | Academic workload overview      |
| My Tasks         | Assignment and task management  |
| AI Study Planner | Natural-language study planning |
| My Schedule      | Weekly study timetable          |

### Screenshots

Screenshots of the application will be added as development progresses.

---

## &#x20;How Planova AI Works

The  workflow follows five stages:

**1. Input** — Students add tasks, deadlines, priorities, and available study hours.

**2. Analyze** — The AI agent interprets the student's academic requirements.

**3. Plan** — The agent generates a personalized study schedule.

**4. Monitor** — The application tracks task and session completion.

**5. Adapt** — When sessions are missed, the agent creates an adjusted schedule.

This **Input → Analyze → Plan → Monitor → Adapt** workflow forms the foundation of Planova AI's proposed agentic behavior.

---

## &#x20;Technology Stack

| Layer             | Technology         |
| ----------------- | ------------------ |
| Frontend          | Jac/Jaseci Web     |
| Backend           | Jac/Jaseci Walkers |
| AI Integration    | ByLLM (planned)    |
| AI Model          | To be finalized    |
| Data Storage      | To be finalized    |
| Development Tools | VS Code            |
| Version Control   | Git & GitHub       |

## System Architecture

```text
                  STUDENT
                     |
                     v
             PLANOVA AI WEB
                     |
          +----------+----------+
          |                     |
          v                     v
     TASK MANAGER         AI STUDY PLANNER
          |                     |
          +----------+----------+
                     |
                     v
               JAC WALKERS
                     |
          +----------+----------+
          |                     |
          v                     v
      TASK STORAGE          AI AGENT
                               |
                               v
                     STUDY PLAN GENERATION
                               |
                               v
                      ADAPTIVE SCHEDULING
                               |
                               v
                       STUDENT DASHBOARD
```

*The architecture illustrates the intended integrated system.*

---

## &#x20;Project Structure

```text
planova/
├── main.jac
├── jac.toml
├── store.jac
├── components/
├── pages/
├── assets/
├── mobile/
│   ├── main.jac
│   ├── theme.jac
│   ├── screens/
│   └── components/
└── cli/
    └── main.jac
```

## &#x20;Getting Started

### Prerequisites

- Python
- Jac/Jaseci
- Git
- VS Code

Navigate into the directory containing `jac.toml`.

**Web**

```bash
jac check .
jac run --dev --no-cache
```

Or: `jac run --dev --no-cache planova`

Open the local URL shown in the terminal, typically `http://localhost:8000`.

**Mobile** (browser preview; run this instead of the web command, not at the same time)

```bash
jac install
jac run --dev --no-cache --platform web mobile
```

Open the App URL printed in the terminal (often `http://localhost:8000` or `/cl/mobile/`). Do not run this at the same time as the web command.

For a device or simulator after one-time setup:

```bash
jac setup mobile
jac run --dev mobile
```

**CLI**

```bash
jac run cli
```

Run only one frontend at a time. Web and Mobile share the Jac client preview folder, so starting one rewrites the preview entry for that app.

### What waits on the backend

Web, Mobile, and CLI all call the same functions in `store.jac`. Until the teammate wires those to Jac walkers, the UIs stay empty and show a connection message. No sample tasks, fake schedules, or simulated AI replies are generated.

| Function | Used for |
| --- | --- |
| `list_tasks` | Dashboard counts, My Tasks |
| `add_task` / `update_task` / `delete_task` / `set_task_status` | Task create, edit, delete, complete |
| `generate_study_plan(prompt, hours_per_day)` | AI Study Planner |
| `list_sessions` / `set_session_status` | My Schedule |
| `replan_missed_sessions` | Replan Missed Sessions |

Do not invent HTTP URLs. Replace each `store.jac` body with the agreed walker or `def:pub` call when the backend is ready. Shared types are `Task` and `StudySession`.

---

## &#x20;

**Frontend Development**

- UI/UX design
- Web pages and navigation
- Task management interface
- AI planner interface
- Schedule visualization
- Frontend API integration

**Backend & AI Development**

- Jac walkers
- Task and schedule persistence
- AI integration using ByLLM
- Study plan generation
- Adaptive rescheduling logic
- API development and validation

## &#x20;Project Goals

Planova AI aims to:

- Improve student time management.
- Reduce missed academic deadlines.
- Support personalized study planning.
- Encourage consistent study habits.
- Demonstrate agentic AI using Jac/Jaseci.
- Provide adaptive schedules instead of fixed timetables.

## &#x20;Future Enhancements

- Study reminders and notifications.
- Student authentication.
- Academic performance analytics.
- Calendar integration.

---

### &#x20;Our Vision

To make academic planning more intelligent, personalized, and adaptable for every student.

**Planova AI — Plan Smarter. Study Better. Achieve More.**

*Developed using Jac/Jaseci as part of a student AI innovation project.*
