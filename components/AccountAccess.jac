"""Sign in or register for a private Planova workspace."""

import from "@jac/runtime" { Link, SignupResult, jacLogin, jacSignup, useNavigate }

def:pub AccountAccess(register: bool = False) -> JsxElement {
    has email: str = "";
    has password: str = "";
    has busy: bool = False;
    has error: str = "";
    nav = useNavigate();
    heading = "Create your free workspace" if register else "Welcome back";
    description = "Your tasks and study plans stay in your own account." if register else "Sign in to continue with your private study plan.";
    switch_copy = "Already have an account? " if register else "New to Planova? ";

    async def handle_access {
        signup_result: SignupResult | None = None;
        login_ok: bool = False;
        if busy { return; }
        busy = True;
        error = "";
        if register and len(password) < 8 {
            error = "Use a password with at least 8 characters.";
            busy = False;
            return;
        }
        try {
            if register {
                signup_result = await jacSignup(email, password);
                if signup_result is None or not signup_result.success {
                    error = "We could not create that account. Check the email or try signing in.";
                    busy = False;
                    return;
                }
            }
            login_ok = await jacLogin(email, password);
            if not login_ok {
                error = "We could not sign you in. Check your email and password.";
                busy = False;
                return;
            }
            nav("/dashboard");
        } except Exception as e {
            error = "Account access failed. Please try again.";
        }
        busy = False;
    }

    async def submit_form(e: FormEvent) {
        e.preventDefault();
        await handle_access();
    }

    <main className="account-page">
        <section className="account-card">
            <Link to="/" className="account-brand"><span className="nav-mark"></span>Planova AI</Link>
            <p className="eyebrow">YOUR STUDY SPACE</p>
            <h1>{heading}</h1>
            <p className="account-description">{description}</p>
            {if error { <p className="notice error" role="alert">{error}</p> }}
            <form className="account-form" onSubmit={submit_form}>
                <label className="field">
                    <span>Email address</span>
                    <input type="email" autoComplete="email" required value={email} onChange={lambda (e: ChangeEvent) { email = e.target.value; }} />
                </label>
                <label className="field">
                    <span>Password</span>
                    <input type="password" autoComplete={"new-password" if register else "current-password"} minLength={8} required value={password} onChange={lambda (e: ChangeEvent) { password = e.target.value; }} />
                </label>
                <button className="btn-primary account-submit" type="submit" disabled={busy}>{"Creating account..." if busy and register else ("Signing in..." if busy else ("Create free account" if register else "Sign in"))}</button>
            </form>
            <p className="account-switch">
                {switch_copy}
                {if register { <Link to="/login">Sign in</Link> } else { <Link to="/signup">Create a free account</Link> }}
            </p>
            <div className="account-divider"><span>or</span></div>
            <Link to="/dashboard" className="account-demo-link">Explore the shared demo without an account →</Link>
        </section>
        <aside className="account-aside">
            <span className="account-aside-icon">⟳</span>
            <p className="eyebrow">A PLAN THAT ADAPTS</p>
            <h2>Real life changes.<br />Your plan can too.</h2>
            <p>Keep deadlines, study sessions, and progress together in one personal workspace.</p>
        </aside>
    </main>
}
