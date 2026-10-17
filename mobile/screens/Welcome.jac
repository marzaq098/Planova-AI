"""Welcome screen with the Planova AI name, tagline, and Get Started."""

import from "@jac/mobui" { View, Text }
import from ..theme { C, F, styles }
import from ..components.Button { Button }
import from ..components.Icon { Icon }

def:pub WelcomeScreen(onStart: Callable[[], None]) -> JsxElement {
    <View style={styles.welcome}>
        <Icon name="sparkles" size={F.xl} color={C.accent} />
        <Text style={styles.brand}>Planova AI</Text>
        <Text style={styles.tagline}>Plan Smarter. Study Better. Achieve More.</Text>
        <Button label="Get Started" onPress={onStart} />
    </View>
}
