"""My Schedule route at /schedule."""

import from ..components.MySchedule { MySchedule }

def:pub SchedulePage -> JsxPage {
    <MySchedule />
}
