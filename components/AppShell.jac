"""Shared sidebar layout for signed-in frontend pages."""

import from .Sidebar { Sidebar }

def:pub AppShell(title: str, children: any = None) -> JsxElement {
    has sidebar_open: bool = False;

    def close_sidebar {
        sidebar_open = False;
    }

    def toggle_sidebar {
        sidebar_open = not sidebar_open;
    }

    <div className="dash">
        {if sidebar_open {
            <button className="dash-backdrop" type="button" aria-label="Close menu" onClick={close_sidebar}></button>
        }}
        <Sidebar open={sidebar_open} onClose={close_sidebar} />
        <div className="dash-main">
            <header className="dash-top">
                <button
                    className="dash-menu"
                    type="button"
                    aria-label="Open sidebar"
                    aria-expanded={sidebar_open}
                    onClick={toggle_sidebar}
                >
                    <span></span>
                    <span></span>
                    <span></span>
                </button>
                <p className="dash-top-title">{title}</p>
            </header>
            {children}
        </div>
    </div>
}
