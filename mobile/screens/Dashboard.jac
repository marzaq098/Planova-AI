"""Mobile dashboard. Counts come from loaded task data only."""

import from "@jac/mobui" { View, Text, ScrollView }
import from store { Task }
import from ..theme { styles }

def:pub DashboardScreen(tasks: list[Task], message: str) -> JsxElement {
    total = len(tasks);
    completed = len([t for t in tasks if t.status == "completed"]);
    pending = len([t for t in tasks if t.status != "completed"]);
    upcoming = len([t for t in tasks if t.status != "completed" and t.deadline]);

    <ScrollView style={styles.screen} contentContainerStyle={styles.body}>
        <View style={styles.header}>
            <Text style={styles.title}>Welcome to Planova AI</Text>
            <Text style={styles.subtitle}>Here is your study overview.</Text>
        </View>
        {if message {
            <Text style={styles.error}>{message}</Text>
        }}
        <View style={styles.stats}>
            <View style={styles.statCard}>
                <Text style={styles.cardLabel}>Total Tasks</Text>
                <Text style={styles.cardValue}>{str(total)}</Text>
            </View>
            <View style={styles.statCard}>
                <Text style={styles.cardLabel}>Completed Tasks</Text>
                <Text style={styles.cardValue}>{str(completed)}</Text>
            </View>
            <View style={styles.statCard}>
                <Text style={styles.cardLabel}>Pending Tasks</Text>
                <Text style={styles.cardValue}>{str(pending)}</Text>
            </View>
            <View style={styles.statCard}>
                <Text style={styles.cardLabel}>Upcoming Deadlines</Text>
                <Text style={styles.cardValue}>{str(upcoming)}</Text>
            </View>
        </View>
        {if total == 0 {
            <Text style={styles.empty}>No tasks yet. Add your first task.</Text>
        }}
    </ScrollView>
}
