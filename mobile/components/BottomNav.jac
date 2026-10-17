"""Simple bottom navigation for the signed-in mobile screens."""

import from "@jac/mobui" { View, Text, Pressable }
import from ..theme { styles }

def:pub NavItem(label: str, name: str, current: str, onChange: Callable[[str], None]) -> JsxElement {
    active = current == name;
    <Pressable
        style={[styles.navItem, styles.navItemOn if active else {}]}
        onPress={lambda { onChange(name); }}
    >
        <Text style={styles.navTextOn if active else styles.navText}>{label}</Text>
    </Pressable>
}

def:pub BottomNav(current: str, onChange: Callable[[str], None]) -> JsxElement {
    <View style={styles.nav}>
        <NavItem label="Home" name="dashboard" current={current} onChange={onChange} />
        <NavItem label="Tasks" name="tasks" current={current} onChange={onChange} />
        <NavItem label="Planner" name="planner" current={current} onChange={onChange} />
        <NavItem label="Schedule" name="schedule" current={current} onChange={onChange} />
    </View>
}
