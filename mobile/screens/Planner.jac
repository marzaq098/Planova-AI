"""Mobile AI Study Planner. Sends prompt and hours; does not invent plans."""

import from "@jac/mobui" { View, Text, TextInput, ScrollView }
import from store { StudySession }
import from ..theme { C, styles }
import from ..components.Button { Button }

def:pub PlanCard(session: StudySession, title: str, priority: str) -> JsxElement {
    <View style={styles.card}>
        <Text style={styles.taskTitle}>{title}</Text>
        <Text style={styles.taskMeta}>Date: {session.date}</Text>
        <Text style={styles.taskMeta}>Time: {session.start_time}</Text>
        <Text style={styles.taskMeta}>Duration: {str(session.duration_minutes)} min</Text>
        <Text style={styles.priority}>{priority}</Text>
    </View>
}

def:pub PlannerScreen(
    study_prompt: str,
    hours_text: str,
    generating: bool,
    sessions: list[StudySession],
    titles: list[str],
    priorities: list[str],
    message: str,
    onPrompt: Callable[[str], None],
    onHours: Callable[[str], None],
    onGenerate: Callable[[], None]
) -> JsxElement {
    <ScrollView style={styles.screen} contentContainerStyle={styles.body}>
        <View style={styles.header}>
            <Text style={styles.title}>AI Study Planner</Text>
            <Text style={styles.subtitle}>Describe what you want to study.</Text>
        </View>
        <View style={styles.field}>
            <Text style={styles.fieldLabel}>Available study hours per day</Text>
            <TextInput
                style={styles.input}
                value={hours_text}
                placeholder="3"
                placeholderTextColor={C.muted}
                onChangeText={onHours}
            />
        </View>
        <View style={styles.field}>
            <Text style={styles.fieldLabel}>What would you like to study?</Text>
            <TextInput
                style={styles.prompt}
                value={study_prompt}
                placeholder="Create a study plan for my upcoming exams. I have Mathematics, Computer Science, and English. I can study 3 hours daily and my exams begin next Monday."
                placeholderTextColor={C.muted}
                multiline={True}
                onChangeText={onPrompt}
            />
        </View>
        <Button
            label={"Generating..." if generating else "Generate Study Plan"}
            onPress={onGenerate}
            disabled={generating}
        />
        {if generating {
            <Text style={styles.loading}>Generating your study plan...</Text>
        }}
        {if message {
            <Text style={styles.error}>{message}</Text>
        }}
        {if not generating and len(sessions) == 0 and not message {
            <Text style={styles.empty}>Your study plan will appear here.</Text>
        }}
        <View style={{gap: 12}}>
            {for (idx, session) in enumerate(sessions) {
                <PlanCard
                    key={session.id}
                    session={session}
                    title={titles[idx] if idx < len(titles) else "Study session"}
                    priority={priorities[idx] if idx < len(priorities) else "Medium"}
                />
            }}
        </View>
    </ScrollView>
}
