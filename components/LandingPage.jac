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
                    <div className="hero-copy">
                        <p className="eyebrow"><span className="eyebrow-dot"></span> YOUR STUDY PLAN, IN SYNC WITH REAL LIFE</p>
                        <h1 className="hero-heading">Miss a session?<br /><span>Your plan adapts.</span></h1>
                        <p className="hero-lede">
                            Planova turns assignments and available hours into a realistic study plan — then reshuffles the remaining work when life gets in the way.
                        </p>
                        <div className="hero-actions">
                            <Link to="/dashboard" className="btn-primary">Try the live demo <span aria-hidden="true">→</span></Link>
                            <Link to="/signup" className="btn-secondary">Create your workspace</Link>
                        </div>
                        <a className="hero-text-link" href="#how-it-works">See how the adaptive plan works ↓</a>
                        <p className="hero-note">No account needed · Shared hackathon demo workspace</p>
                    </div>
                    <div className="hero-visual" aria-label="Preview of an adaptive study schedule">
                        <div className="visual-orbit orbit-one"></div>
                        <div className="visual-orbit orbit-two"></div>
                        <div className="planner-preview">
                            <div className="preview-topline"><span className="preview-brand"><span className="preview-mark"></span> This week</span><span className="preview-date">3 assignments · 3h today</span></div>
                            <div className="preview-progress"><div><span className="preview-kicker">YOUR FOCUS PLAN</span><strong>Small steps. Clear head.</strong></div><span className="progress-ring"><b>3h</b></span></div>
                            <div className="preview-session session-current"><span className="session-time">09:00</span><span className="session-line"></span><span className="session-info"><b>Calculus practice</b><small>90 min · High priority</small></span><span className="session-check">✓</span></div>
                            <div className="preview-session"><span className="session-time">10:45</span><span className="session-line"></span><span className="session-info"><b>Biology review</b><small>90 min · Due tomorrow</small></span><span className="session-pill">UP NEXT</span></div>
                            <div className="preview-insight"><span className="insight-spark">✦</span><span><b>Plan ready</b><small>Fits your 3 available hours</small></span></div>
                        </div>
                        <div className="float-chip chip-deadline"><span>↗</span><div><b>Deadline aware</b><small>Prioritized by urgency</small></div></div>
                        <div className="float-chip chip-adapt"><span>⟳</span><div><b>Ready to adapt</b><small>Missed time? Replan.</small></div></div>
                    </div>
                </div>
            </section>
            <section id="how-it-works" className="how-section">
                <div className="section-heading">
                    <p className="eyebrow">A PLAN THAT KEEPS UP</p>
                    <h2>From overloaded to <span>on track.</span></h2>
                    <p>One clear loop: understand the workload, make a realistic plan, then adjust as the week changes.</p>
                </div>
                <div className="steps-grid">
                    <article className="step-card"><span className="step-number">01</span><span className="step-icon">▤</span><h3>Add your work</h3><p>Capture assignments, due dates, priorities, and the time each one needs.</p></article>
                    <article className="step-card"><span className="step-number">02</span><span className="step-icon">◷</span><h3>Plan your hours</h3><p>Build a schedule around the study time you actually have available.</p></article>
                    <article className="step-card step-featured"><span className="step-number">03</span><span className="step-icon">⟳</span><h3>Adapt when plans change</h3><p>Mark a session missed. Planova rechecks deadlines and reorganizes the remaining work.</p></article>
                </div>
            </section>
            <section className="account-bridge">
                <div><p className="eyebrow">READY TO MAKE IT YOURS?</p><h2>Start free. Keep your study data private.</h2><p>Create an account for your own workspace. Want to explore first? The shared demo is ready with no sign-in.</p></div>
                <div className="account-bridge-actions"><Link to="/signup" className="btn-primary">Create free account</Link><Link to="/dashboard" className="text-btn">Continue to shared demo</Link></div>
            </section>
            <section id="features" className="features">
                <div className="features-inner">
                    <div className="section-heading features-heading">
                        <p className="eyebrow">BUILT FOR BUSY STUDENTS</p>
                        <h2>More clarity. <span>Less catch-up panic.</span></h2>
                    </div>
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
            <section className="demo-callout">
                <div className="callout-copy"><p className="eyebrow">THE PLANOVA DIFFERENCE</p><h2>A missed session is a moment to <span>replan</span>, not give up.</h2><p>Try the full flow in the demo workspace: add a few assignments, generate a capped study plan, then mark a session missed and watch the schedule adjust.</p><Link to="/dashboard" className="btn-primary">Explore the demo <span aria-hidden="true">→</span></Link></div>
                <div className="replan-card"><div className="replan-label"><span className="replan-dot"></span> PLAN UPDATED</div><div className="replan-before"><span className="replan-x">×</span><div><b>09:00 · Calculus</b><small>Session missed</small></div></div><div className="replan-arrow">↓</div><div className="replan-after"><span className="replan-check">✓</span><div><b>11:00 · Calculus</b><small>Moved into your next open block</small></div></div><p className="replan-foot">Still within your available study hours</p></div>
            </section>
        </main>
        <Footer />
    </div>
}
