"""Mobile task list and form. Uses backend task APIs when they are available."""

import from "@jac/mobui" { View, Text, TextInput, ScrollView, Pressable }
import from store { Task }
import from ..theme { C, styles }
import from ..components.Button { Button }

def:pub TaskCard(
    task: Task,
    onToggle: Callable[[str], None],
    onEdit: Callable[[str], None],
    onDelete: Callable[[str], None]
) -> JsxElement {
    <View style={styles.card}>
        <Text style={styles.taskTitle}>{task.title}</Text>
        <Text style={styles.taskMeta}>{task.deadline} · {task.status}</Text>
        <Text style={styles.priority}>{task.priority}</Text>
        <View style={styles.actions}>
            <Button
                label={"Undo" if task.status == "completed" else "Complete"}
                variant="secondary"
                onPress={lambda { onToggle(task.id); }}
            />
            <Button label="Edit" variant="secondary" onPress={lambda { onEdit(task.id); }} />
            <Button label="Delete" variant="secondary" onPress={lambda { onDelete(task.id); }} />
        </View>
    </View>
}

def:pub PriorityChip(label: str, current: str, onPick: Callable[[str], None]) -> JsxElement {
    active = current == label;
    <Pressable
        style={[styles.chip, styles.chipOn if active else {}]}
        onPress={lambda { onPick(label); }}
    >
        <Text style={styles.chipTextOn if active else styles.chipText}>{label}</Text>
    </Pressable>
}

def:pub TasksScreen(
    tasks: list[Task],
    title: str,
    description: str,
    deadline: str,
    priority: str,
    hours_text: str,
    editing: bool,
    message: str,
    onTitle: Callable[[str], None],
    onDescription: Callable[[str], None],
    onDeadline: Callable[[str], None],
    onPriority: Callable[[str], None],
    onHours: Callable[[str], None],
    onSave: Callable[[], None],
    onEdit: Callable[[str], None],
    onDelete: Callable[[str], None],
    onToggle: Callable[[str], None]
) -> JsxElement {
    <ScrollView style={styles.screen} contentContainerStyle={styles.body}>
        <View style={styles.header}>
            <Text style={styles.title}>My Tasks</Text>
            <Text style={styles.subtitle}>Add, edit, and track your assignments.</Text>
        </View>
        <View style={styles.card}>
            <Text style={styles.cardLabel}>{ "Edit task" if editing else "Add a new task" }</Text>
            <View style={styles.field}>
                <Text style={styles.fieldLabel}>Title</Text>
                <TextInput
                    style={styles.input}
                    value={title}
                    placeholder="Task title"
                    placeholderTextColor={C.muted}
                    onChangeText={onTitle}
                />
            </View>
            <View style={styles.field}>
                <Text style={styles.fieldLabel}>Deadline</Text>
                <TextInput
                    style={styles.input}
                    value={deadline}
                    placeholder="YYYY-MM-DD"
                    placeholderTextColor={C.muted}
                    onChangeText={onDeadline}
                />
            </View>
            <View style={styles.field}>
                <Text style={styles.fieldLabel}>Priority</Text>
                <View style={styles.chips}>
                    <PriorityChip label="High" current={priority} onPick={onPriority} />
                    <PriorityChip label="Medium" current={priority} onPick={onPriority} />
                    <PriorityChip label="Low" current={priority} onPick={onPriority} />
                </View>
            </View>
            <View style={styles.field}>
                <Text style={styles.fieldLabel}>Estimated hours</Text>
                <TextInput
                    style={styles.input}
                    value={hours_text}
                    placeholder="1"
                    placeholderTextColor={C.muted}
                    onChangeText={onHours}
                />
            </View>
            <View style={styles.field}>
                <Text style={styles.fieldLabel}>Description</Text>
                <TextInput
                    style={styles.input}
                    value={description}
                    placeholder="Optional details"
                    placeholderTextColor={C.muted}
                    onChangeText={onDescription}
                />
            </View>
            <Button label={"Save Task" if editing else "Add Task"} onPress={onSave} />
        </View>
        {if message {
            <Text style={styles.error}>{message}</Text>
        }}
        {if len(tasks) == 0 {
            <Text style={styles.empty}>No tasks yet. Add your first task.</Text>
        }}
        <View style={{gap: 12}}>
            {for task in tasks {
                <TaskCard
                    key={task.id}
                    task={task}
                    onToggle={onToggle}
                    onEdit={onEdit}
                    onDelete={onDelete}
                />
            }}
        </View>
    </ScrollView>
}
