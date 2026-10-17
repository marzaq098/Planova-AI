"""Free and planned premium options, with no pretend checkout."""

import from "@jac/runtime" { Link }

def:pub PricingPage -> JsxElement {
    <div className="pricing-page">
        <header className="pricing-nav">
            <Link to="/" className="account-brand"><span className="nav-mark"></span>Planova AI</Link>
            <nav><Link to="/login">Sign in</Link><Link to="/dashboard">Try the demo</Link></nav>
        </header>
        <main>
            <section className="pricing-intro">
                <p className="eyebrow">PLANS FOR EVERY STUDY SEASON</p>
                <h1>Keep your plan moving.</h1>
                <p>The core planner stays free. Premium will add deeper study insights and longer-range planning when paid checkout is ready.</p>
            </section>
            <section className="pricing-grid" aria-label="Plan comparison">
                <article className="price-card">
                    <p className="plan-label">PLANOVA FREE</p>
                    <h2>Free</h2>
                    <p className="plan-price">$0 <span>forever</span></p>
                    <p className="plan-copy">Everything you need to organize your assignments and recover when plans change.</p>
                    <ul>
                        <li>Assignment and deadline tracking</li>
                        <li>Daily study plans within your available hours</li>
                        <li>Missed-session replanning</li>
                        <li>Personal account and private workspace</li>
                    </ul>
                    <Link to="/signup" className="btn-secondary plan-button">Create a free account</Link>
                </article>
                <article className="price-card premium-card">
                    <span className="coming-badge">IN DEVELOPMENT</span>
                    <p className="plan-label">PLANOVA PLUS</p>
                    <h2>Premium</h2>
                    <p className="plan-price">$3.99 <span>/ month</span></p>
                    <p className="annual-price">Choose monthly at $3.99 or yearly at $29.99. Both start with a 3-day trial.</p>
                    <p className="plan-copy">More visibility and guidance for students balancing several courses and exam dates.</p>
                    <ul>
                        <li>Multi-week exam preparation plans</li>
                        <li>Workload and progress insights across courses</li>
                        <li>AI study coach for prioritization and explanations</li>
                        <li>Calendar export and advanced planning controls</li>
                    </ul>
                    <button className="btn-primary plan-button" type="button" disabled>Premium trial opening soon</button>
                    <p className="payment-methods">Planned payment options: credit/debit card or PayPal</p>
                    <p className="billing-note">The trial will require a card or PayPal account and will renew at the selected price unless cancelled. Checkout is not active yet, and this page takes no payment.</p>
                </article>
            </section>
            <section className="pricing-footnote"><span>✦</span><p>Core scheduling and automatic replanning remain free. Premium adds optional depth; it won’t block students from recovering a missed study session.</p></section>
        </main>
    </div>
}
