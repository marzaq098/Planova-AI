"""AI Study Planner route at /planner."""

import from ..components.StudyPlanner { StudyPlanner }

def:pub PlannerPage -> JsxPage {
    <StudyPlanner />
}
