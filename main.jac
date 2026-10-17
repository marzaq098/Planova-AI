"""Planova AI client entry and one-time splash transition."""

import "./assets/global.css";
import from .components.SplashScreen { SplashScreen }

def:pub app(children: any) -> JsxElement {
    has show_splash: bool = True;
    has fade_out: bool = False;

    can with entry {
        setTimeout(lambda {
            fade_out = True;
            setTimeout(lambda {
                show_splash = False;
            }, 450);
        }, 2200);
    }

    if show_splash {
        return <SplashScreen fading={fade_out} />;
    }
    return <>{children}</>;
}
