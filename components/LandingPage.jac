"""Public landing page for Planova AI."""

import from "@jac/runtime" { Link }
import from .Navbar { Navbar }
import from .FeatureCard { FeatureCard }
import from .Footer { Footer }

def:pub LandingPage -> JsxElement {
    <div className="page landing-enter">
        <Navbar />
        <main>
            <section id="home" className="hero">
                <div className="hero-inner">
                    <h1 className="hero-heading">Study Smarter with Planova AI</h1>
                    <p className="hero-lede">
                        Your AI-powered study companion that helps you organize tasks,
                        manage deadlines, and create smarter study schedules.
                    </p>
                    <div className="hero-actions">
                        <Link to="/dashboard" className="btn-primary">Get Started</Link>
                        <a className="btn-secondary" href="#features">Learn More</a>
                    </div>
                </div>
            </section>
            <section id="features" className="features">
                <div className="features-inner">
                    <div className="feature-grid">
                        <FeatureCard
                            title="Task Management"
                            description="Keep assignments, notes, and study goals organized in one simple workspace."
                            icon="tasks"
                        />
                        <FeatureCard
                            title="AI Study Planner"
                            description="Turn your workload into a focused plan that fits the time you actually have."
                            icon="planner"
                        />
                        <FeatureCard
                            title="Adaptive Scheduling"
                            description="Schedules that adjust as deadlines change, so you always know what to study next."
                            icon="schedule"
                        />
                    </div>
                </div>
            </section>
        </main>
        <Footer />
    </div>
}
