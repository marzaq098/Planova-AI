"""Mobile weekly schedule. Shows only sessions returned by the backend."""

import from "@jac/mobui" { View, Text, ScrollView }
import from store { StudySession, Task, task_title }
import from ..theme { styles }
import from ..components.Button { Button }

def:pub SessionCard(
    session: StudySession,
    title: str,
    onComplete: Callable[[str], None]
) -> JsxElement {
    <View style={styles.card}>
        <Text style={styles.taskTitle}>{title}</Text>
        <Text style={styles.taskMeta}>{session.start_time} · {str(session.duration_minutes)} min</Text>
        <Text style={styles.priority}>{session.status}</Text>
        <Button
            label={"Undo" if session.status == "completed" else "Mark completed"}
            variant="secondary"
            onPress={lambda { onComplete(session.id); }}
        />
    </View>
}

def:pub DayGroup(
    date: str,
    sessions: list[StudySession],
    tasks: list[Task],
    onComplete: Callable[[str], None]
) -> JsxElement {
    <View style={styles.card}>
        <Text style={styles.taskTitle}>{date}</Text>
        {for session in sessions {
            if session.date == date {
                <SessionCard
                    key={session.id}
                    session={session}
                    title={task_title(tasks, session.task_id)}
                    onComplete={onComplete}
                />
            }
        }}
    </View>
}

def:pub ScheduleScreen(
    dates: list[str],
    sessions: list[StudySession],
    tasks: list[Task],
    replanning: bool,
    message: str,
    onComplete: Callable[[str], None],
    onReplan: Callable[[], None]
) -> JsxElement {
    <ScrollView style={styles.screen} contentContainerStyle={styles.body}>
        <View style={styles.header}>
            <Text style={styles.title}>My Schedule</Text>
            <Text style={styles.subtitle}>Study sessions grouped by day.</Text>
        </View>
        <Button
            label={"Replanning..." if replanning else "Replan Missed Sessions"}
            variant="secondary"
            onPress={onReplan}
            disabled={replanning}
        />
        {if message {
            <Text style={styles.error}>{message}</Text>
        }}
        {if len(sessions) == 0 {
            <Text style={styles.empty}>No study schedule yet</Text>
        }}
        {for date in dates {
            <DayGroup
                key={date}
                date={date}
                sessions={sessions}
                tasks={tasks}
                onComplete={onComplete}
            />
        }}
    </ScrollView>
}
