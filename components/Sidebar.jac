"""App sidebar with links to existing frontend pages."""

import from "@jac/runtime" { Link, useLocation }

def:pub Sidebar(open: bool, onClose: Callable[[], None]) -> JsxElement {
    location = useLocation();
    path = location.pathname;
    side_cls = "sidebar open" if open else "sidebar";

    def item_cls(href: str) -> str {
        return "side-link active" if path == href else "side-link";
    }

    <aside className={side_cls} aria-label="App">
        <Link to="/dashboard" className="side-logo" onClick={onClose}>
            <span className="nav-mark" aria-hidden="true"></span>
            <span>Planova AI</span>
        </Link>
        <nav className="side-nav">
            <Link to="/dashboard" className={item_cls("/dashboard")} onClick={onClose}>
                <span className="side-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="1.8">
                        <rect x="4" y="4" width="7" height="7" rx="1.5"></rect>
                        <rect x="13" y="4" width="7" height="7" rx="1.5"></rect>
                        <rect x="4" y="13" width="7" height="7" rx="1.5"></rect>
                        <rect x="13" y="13" width="7" height="7" rx="1.5"></rect>
                    </svg>
                </span>
                Dashboard
            </Link>
            <Link to="/tasks" className={item_cls("/tasks")} onClick={onClose}>
                <span className="side-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="1.8">
                        <rect x="4" y="4" width="16" height="16" rx="3"></rect>
                        <path d="M8 12.2l2.2 2.2L16 8.8"></path>
                    </svg>
                </span>
                My Tasks
            </Link>
            <Link to="/planner" className={item_cls("/planner")} onClick={onClose}>
                <span className="side-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="1.8">
                        <circle cx="12" cy="12" r="8"></circle>
                        <path d="M12 8v4l3 1.8"></path>
                    </svg>
                </span>
                AI Study Planner
            </Link>
            <Link to="/schedule" className={item_cls("/schedule")} onClick={onClose}>
                <span className="side-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="1.8">
                        <rect x="4" y="5" width="16" height="15" rx="3"></rect>
                        <path d="M8 3.5V7M16 3.5V7M4 10h16"></path>
                    </svg>
                </span>
                My Schedule
            </Link>
        </nav>
        <Link to="/" className="side-link logout" onClick={onClose}>
            <span className="side-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="1.8">
                    <path d="M10 7V5.5A1.5 1.5 0 0 1 11.5 4h7A1.5 1.5 0 0 1 20 5.5v13a1.5 1.5 0 0 1-1.5 1.5h-7A1.5 1.5 0 0 1 10 18.5V17"></path>
                    <path d="M4 12h10M12 9l3 3-3 3"></path>
                </svg>
            </span>
            Logout
        </Link>
    </aside>
}
