"""Centered splash screen shown before the landing page."""

def:pub SplashScreen(fading: bool = False) -> JsxElement {
    splash_cls = "splash fading" if fading else "splash";

    <section className={splash_cls} aria-label="Loading Planova AI" aria-busy="true">
        <div className="splash-content">
            <p className="splash-brand">Planova AI</p>
            <p className="splash-tagline">Plan Smarter. Study Better. Achieve More.</p>
            <div className="splash-loader" aria-hidden="true">
                <span className="splash-dot"></span>
                <span className="splash-dot"></span>
                <span className="splash-dot"></span>
            </div>
        </div>
    </section>
}
