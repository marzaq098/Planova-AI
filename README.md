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
│   ├── AppShell.jac
│   ├── Sidebar.jac
│   ├── Dashboard.jac
│   ├── MyTasks.jac
│   ├── StudyPlanner.jac
│   └── MySchedule.jac
├── pages/
│   ├── index.jac
│   ├── dashboard.jac
│   ├── tasks.jac
│   ├── planner.jac
│   └── schedule.jac
└── assets/
    └── global.css
```

## &#x20;Getting Started

### Prerequisites

- Python
- Jac/Jaseci
- Git
- VS Code


Navigate into the directory containing `jac.toml` and `main.jac`.

Run the application:

```bash
jac check .
jac run --dev --no-cache main.jac
```

Open the local URL shown in the terminal, typically:

`http://localhost:8000`

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
- Mobile application support.

---

### &#x20;Our Vision

To make academic planning more intelligent, personalized, and adaptable for every student.

**Planova AI — Plan Smarter. Study Better. Achieve More.**

*Developed using Jac/Jaseci as part of a student AI innovation project.*
