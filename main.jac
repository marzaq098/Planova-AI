"""Planova frontend entry point; the API lives in backend/api.jac."""

import "./assets/global.css";
import from .components.SplashScreen { SplashScreen }
import from .backend.api {
    health,
    list_tasks,
    add_task,
    update_task,
    set_task_status,
    delete_task,
    list_sessions,
    set_session_status,
    generate_study_plan,
    replan_missed_sessions
}

def:pub app(children: any) -> JsxElement {
    has show_splash: bool = True;
    has fade_out: bool = False;

    can with entry {
        setTimeout(lambda {
            fade_out = True;
            setTimeout(lambda { show_splash = False; }, 450);
        }, 2200);
    }

    if show_splash { return <SplashScreen fading={fade_out} />; }
    return <>{children}</>;
}
