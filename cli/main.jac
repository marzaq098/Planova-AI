"""Planova AI command-line interface. Frontend only — no mock AI or walkers."""

import sys;
import from store {
    Task, add_task, delete_task, generate_study_plan, list_sessions, list_tasks,
    replan_missed_sessions, set_session_status, set_task_status, task_title,
    unique_session_dates, update_task
}

def read_line(label: str) -> str {
    try {
        return input(label).strip();
    } except Exception {
        return "";
    }
}

def pause {
    read_line("Press Enter to continue: ");
}

def show_menu {
    print("");
    print("==================================");
    print("           PLANOVA AI");
    print("     Adaptive AI Study Agent");
    print("==================================");
    print("");
    print("1. View Dashboard");
    print("2. View My Tasks");
    print("3. Add New Task");
    print("4. Update Task");
    print("5. Complete Task");
    print("6. Delete Task");
    print("7. Generate AI Study Plan");
    print("8. View My Schedule");
    print("9. Replan Missed Sessions");
    print("0. Exit");
    print("");
}

def print_tasks(tasks: list[Task]) {
    if len(tasks) == 0 {
        print("No tasks yet.");
        return;
    }
    print("");
    print("ID | Title | Deadline | Priority | Status | Hours");
    print("--------------------------------------------------");
    for t in tasks {
        print(f"{t.id} | {t.title} | {t.deadline} | {t.priority} | {t.status} | {t.estimated_hours}");
    }
}

def find_by_id(tasks: list[Task], task_id: str) -> Task | None {
    for t in tasks {
        if t.id == task_id {
            return t;
        }
    }
    return None;
}

def parse_hours(text: str, fallback: float) -> float {
    if not text {
        return fallback;
    }
    try {
        return float(text);
    } except Exception {
        print("That was not a number. Using the default instead.");
        return fallback;
    }
}

def view_dashboard {
    result = list_tasks();
    tasks = result.items;
    total = len(tasks);
    completed = len([t for t in tasks if t.status == "completed"]);
    pending = len([t for t in tasks if t.status != "completed"]);
    upcoming = len([t for t in tasks if t.status != "completed" and t.deadline]);
    print("");
    print("Dashboard");
    print(f"Total Tasks: {total}");
    print(f"Completed Tasks: {completed}");
    print(f"Pending Tasks: {pending}");
    print(f"Upcoming Deadlines: {upcoming}");
    if not result.connected {
        print(result.message);
    }
    pause();
}

def view_tasks {
    result = list_tasks();
    print("");
    print("My Tasks");
    if not result.connected {
        print(result.message);
    }
    print_tasks(result.items);
    pause();
}

def add_new_task {
    print("");
    print("Add New Task");
    title = read_line("Title: ");
    if not title {
        print("A title is required.");
        pause();
        return;
    }
    description = read_line("Description (optional): ");
    deadline = read_line("Deadline (YYYY-MM-DD, optional): ");
    priority = read_line("Priority High/Medium/Low [Medium]: ");
    if priority != "High" and priority != "Medium" and priority != "Low" {
        if priority {
            print("Unknown priority. Using Medium.");
        }
        priority = "Medium";
    }
    hours = parse_hours(read_line("Estimated hours [1]: "), 1.0);
    result = add_task(title, description, deadline, priority, hours);
    if result.connected {
        print("Task saved.");
    } else {
        print(result.message);
    }
    pause();
}

def update_existing_task {
    loaded = list_tasks();
    if not loaded.connected {
        print(loaded.message);
        pause();
        return;
    }
    tasks = loaded.items;
    print_tasks(tasks);
    if len(tasks) == 0 {
        pause();
        return;
    }
    task_id = read_line("Enter the task ID to update: ");
    current = find_by_id(tasks, task_id);
    if current is None {
        print("No task has that ID.");
        pause();
        return;
    }
    title = read_line(f"Title [{current.title}]: ");
    if not title {
        title = current.title;
    }
    description = read_line(f"Description [{current.description}]: ");
    if not description {
        description = current.description;
    }
    deadline = read_line(f"Deadline [{current.deadline}]: ");
    if not deadline {
        deadline = current.deadline;
    }
    priority = read_line(f"Priority [{current.priority}]: ");
    if priority != "High" and priority != "Medium" and priority != "Low" {
        priority = current.priority;
    }
    hours = parse_hours(read_line(f"Estimated hours [{current.estimated_hours}]: "), current.estimated_hours);
    result = update_task(Task(
        id=current.id,
        title=title,
        description=description,
        deadline=deadline,
        priority=priority,
        status=current.status,
        estimated_hours=hours
    ));
    if result.connected {
        print("Task updated.");
    } else {
        print(result.message);
    }
    pause();
}

def complete_existing_task {
    loaded = list_tasks();
    if not loaded.connected {
        print(loaded.message);
        pause();
        return;
    }
    tasks = loaded.items;
    print_tasks(tasks);
    if len(tasks) == 0 {
        pause();
        return;
    }
    task_id = read_line("Enter the task ID to complete or undo: ");
    current = find_by_id(tasks, task_id);
    if current is None {
        print("No task has that ID.");
        pause();
        return;
    }
    next_status = "pending" if current.status == "completed" else "completed";
    result = set_task_status(task_id, next_status);
    if result.connected {
        print(f"Task is now {next_status}.");
    } else {
        print(result.message);
    }
    pause();
}

def delete_existing_task {
    loaded = list_tasks();
    if not loaded.connected {
        print(loaded.message);
        pause();
        return;
    }
    tasks = loaded.items;
    print_tasks(tasks);
    if len(tasks) == 0 {
        pause();
        return;
    }
    task_id = read_line("Enter the task ID to delete: ");
    current = find_by_id(tasks, task_id);
    if current is None {
        print("No task has that ID.");
        pause();
        return;
    }
    result = delete_task(task_id);
    if result.connected {
        print("Task deleted.");
    } else {
        print(result.message);
    }
    pause();
}

def generate_plan {
    print("");
    print("Generate AI Study Plan");
    prompt = read_line("What would you like to study? ");
    if not prompt {
        print("Please describe the study plan you want.");
        pause();
        return;
    }
    hours = parse_hours(read_line("Available study hours per day [3]: "), 3.0);
    print("Generating your study plan...");
    result = generate_study_plan(prompt, hours);
    if not result.connected {
        print("Unable to generate your plan right now. Please try again.");
        if result.message {
            print(result.message);
        }
        pause();
        return;
    }
    if len(result.items) == 0 {
        print("The planner returned no study sessions.");
        pause();
        return;
    }
    loaded = list_tasks();
    tasks = loaded.items;
    print("");
    print("Study Plan");
    print("Subject | Date | Time | Duration | Priority");
    print("-------------------------------------------");
    for s in result.items {
        print(
            f"{task_title(tasks, s.task_id)} | {s.date} | {s.start_time} | {s.duration_minutes} min | {s.status}"
        );
    }
    pause();
}

def view_schedule {
    result = list_sessions();
    print("");
    print("My Schedule");
    if not result.connected {
        print(result.message);
        print("No study schedule yet");
        pause();
        return;
    }
    if len(result.items) == 0 {
        print("No study schedule yet");
        pause();
        return;
    }
    loaded = list_tasks();
    tasks = loaded.items;
    dates = unique_session_dates(result.items);
    for date in dates {
        print("");
        print(date);
        for s in result.items {
            if s.date == date {
                print(
                    f"  - {task_title(tasks, s.task_id)} | {s.start_time} | {s.duration_minutes} min | {s.status} | id={s.id}"
                );
            }
        }
    }
    session_id = read_line("Enter a session ID to mark completed, or press Enter to skip: ");
    if session_id {
        current = "pending";
        found = False;
        for s in result.items {
            if s.id == session_id {
                current = s.status;
                found = True;
            }
        }
        if not found {
            print("No session has that ID.");
        } else {
            next_status = "pending" if current == "completed" else "completed";
            changed = set_session_status(session_id, next_status);
            if changed.connected {
                print(f"Session is now {next_status}.");
            } else {
                print(changed.message);
            }
        }
    }
    pause();
}

def replan_sessions {
    print("");
    print("Replan Missed Sessions");
    result = replan_missed_sessions();
    if result.connected {
        print(f"Updated schedule has {len(result.items)} session(s).");
    } else {
        print(result.message);
    }
    pause();
}

def main -> int {
    running = True;
    while running {
        show_menu();
        choice = read_line("Enter your choice: ");
        if not choice or choice == "0" {
            print("Goodbye.");
            running = False;
        } elif choice == "1" {
            view_dashboard();
        } elif choice == "2" {
            view_tasks();
        } elif choice == "3" {
            add_new_task();
        } elif choice == "4" {
            update_existing_task();
        } elif choice == "5" {
            complete_existing_task();
        } elif choice == "6" {
            delete_existing_task();
        } elif choice == "7" {
            generate_plan();
        } elif choice == "8" {
            view_schedule();
        } elif choice == "9" {
            replan_sessions();
        } else {
            print("Please enter a number from 0 to 9.");
        }
    }
    return 0;
}

with entry:__main__ {
    sys.`exit(main());
}
