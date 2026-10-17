"""Landing page route at /."""

import from ..components.LandingPage { LandingPage }

def:pub Home -> JsxPage {
    <LandingPage />
}
