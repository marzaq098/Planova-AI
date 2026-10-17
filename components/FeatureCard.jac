"""Simple feature card used on the landing page."""

def:pub FeatureCard(title: str, description: str, icon: str) -> JsxElement {
    <article className="feature-card">
        <div className="feature-icon" aria-hidden="true">
            {if icon == "tasks" {
                <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" strokeWidth="1.8">
                    <rect x="4" y="4" width="16" height="16" rx="3"></rect>
                    <path d="M8 12.2l2.2 2.2L16 8.8"></path>
                </svg>
            }}
            {if icon == "planner" {
                <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" strokeWidth="1.8">
                    <circle cx="12" cy="12" r="8"></circle>
                    <path d="M12 8v4l3 1.8"></path>
                </svg>
            }}
            {if icon == "schedule" {
                <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" strokeWidth="1.8">
                    <rect x="4" y="5" width="16" height="15" rx="3"></rect>
                    <path d="M8 3.5V7M16 3.5V7M4 10h16"></path>
                </svg>
            }}
        </div>
        <h3 className="feature-title">{title}</h3>
        <p className="feature-copy">{description}</p>
    </article>
}
