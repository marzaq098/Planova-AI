"""Top navigation for the Planova AI landing page."""

import from "@jac/runtime" { Link }

def:pub Navbar -> JsxElement {
    has menu_open: bool = False;

    def close_menu {
        menu_open = False;
    }

    def toggle_menu {
        menu_open = not menu_open;
    }

    nav_cls = "nav-links open" if menu_open else "nav-links";

    <header className="nav-bar">
        <div className="nav-inner">
            <a href="#home" className="nav-logo" onClick={close_menu}>
                <span className="nav-mark" aria-hidden="true"></span>
                <span>Planova AI</span>
            </a>
            <button
                className="nav-toggle"
                type="button"
                aria-label="Toggle navigation"
                aria-expanded={menu_open}
                onClick={toggle_menu}
            >
                <span></span>
                <span></span>
                <span></span>
            </button>
            <nav className={nav_cls} aria-label="Primary">
                <a href="#home" onClick={close_menu}>Home</a>
                <a href="#features" onClick={close_menu}>Features</a>
                <Link to="/dashboard" className="nav-login" onClick={close_menu}>Login</Link>
                <Link to="/dashboard" className="nav-cta" onClick={close_menu}>Get Started</Link>
            </nav>
        </div>
    </header>
}
