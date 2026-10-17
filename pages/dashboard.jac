"""Dashboard route at /dashboard."""

import from ..components.Dashboard { Dashboard }

def:pub DashboardPage -> JsxPage {
    <Dashboard />
}
