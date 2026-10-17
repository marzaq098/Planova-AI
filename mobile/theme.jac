"""Planova AI mobile design tokens. Matches the web purple and blue accents."""

import from "@jac/mobui" { StyleSheet }

obj Palette {
    has bg: str = "#ffffff",
        soft: str = "#f6f5ff",
        surface: str = "#ffffff",
        border: str = "#e7e4f5",
        field: str = "#ffffff",
        text: str = "#1c1830",
        muted: str = "#5e5a72",
        accent: str = "#6d5ef0",
        accentSoft: str = "#ece8ff",
        blue: str = "#4f8cff",
        blueSoft: str = "#e8f1ff",
        onAccent: str = "#ffffff",
        danger: str = "#b42318",
        dangerSoft: str = "#fde8e8";
}

obj Spacing {
    has xs: int = 4,
        sm: int = 8,
        md: int = 12,
        lg: int = 16,
        xl: int = 24;
}

obj Radius {
    has sm: int = 8,
        md: int = 12,
        lg: int = 18,
        pill: int = 999;
}

obj FontSize {
    has sm: int = 13,
        md: int = 16,
        lg: int = 20,
        xl: int = 28;
}

glob:pub C: Palette = Palette(),
     S: Spacing = Spacing(),
     R: Radius = Radius(),
     F: FontSize = FontSize();

glob:pub styles = StyleSheet.create({
    screen: {flex: 1, backgroundColor: C.bg},
    body: {flex: 1, padding: S.lg, gap: S.lg, paddingBottom: 88},
    welcome: {
        flex: 1,
        backgroundColor: C.bg,
        padding: S.xl,
        justifyContent: "center",
        alignItems: "center",
        gap: S.lg
    },
    brand: {color: C.accent, fontSize: F.xl, fontWeight: "bold", textAlign: "center"},
    tagline: {color: C.muted, fontSize: F.md, textAlign: "center"},
    header: {gap: S.xs},
    title: {color: C.text, fontSize: F.xl, fontWeight: "bold"},
    subtitle: {color: C.muted, fontSize: F.sm},
    card: {
        backgroundColor: C.surface,
        borderWidth: 1,
        borderColor: C.border,
        borderRadius: R.lg,
        padding: S.lg,
        gap: S.sm
    },
    cardLabel: {color: C.muted, fontSize: F.sm, fontWeight: "600"},
    cardValue: {color: C.accent, fontSize: F.xl, fontWeight: "bold"},
    stats: {flexDirection: "row", flexWrap: "wrap", gap: S.md},
    statCard: {
        flexGrow: 1,
        flexBasis: "40%",
        backgroundColor: C.soft,
        borderRadius: R.md,
        padding: S.lg,
        gap: S.xs
    },
    field: {gap: S.xs},
    fieldLabel: {color: C.muted, fontSize: F.sm, fontWeight: "600"},
    input: {
        color: C.text,
        fontSize: F.md,
        backgroundColor: C.field,
        borderWidth: 1,
        borderColor: C.border,
        borderRadius: R.md,
        paddingVertical: S.md,
        paddingHorizontal: S.lg
    },
    prompt: {
        color: C.text,
        fontSize: F.md,
        backgroundColor: C.field,
        borderWidth: 1,
        borderColor: C.border,
        borderRadius: R.md,
        paddingVertical: S.md,
        paddingHorizontal: S.lg,
        minHeight: 140,
        textAlignVertical: "top"
    },
    row: {
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "space-between",
        gap: S.sm
    },
    chips: {flexDirection: "row", flexWrap: "wrap", gap: S.sm},
    chip: {
        borderWidth: 1,
        borderColor: C.border,
        borderRadius: R.pill,
        paddingVertical: S.xs,
        paddingHorizontal: S.md,
        backgroundColor: C.bg
    },
    chipOn: {backgroundColor: C.accentSoft, borderColor: C.accent},
    chipText: {color: C.muted, fontSize: F.sm, fontWeight: "700"},
    chipTextOn: {color: C.accent, fontSize: F.sm, fontWeight: "700"},
    taskTitle: {color: C.text, fontSize: F.md, fontWeight: "700"},
    taskMeta: {color: C.muted, fontSize: F.sm},
    empty: {color: C.muted, fontSize: F.sm, textAlign: "center", paddingVertical: S.xl},
    error: {
        color: C.danger,
        backgroundColor: C.dangerSoft,
        borderRadius: R.md,
        padding: S.md,
        fontSize: F.sm,
        fontWeight: "600"
    },
    loading: {color: C.muted, fontSize: F.sm},
    actions: {flexDirection: "row", flexWrap: "wrap", gap: S.sm},
    nav: {
        position: "absolute",
        left: 0,
        right: 0,
        bottom: 0,
        flexDirection: "row",
        backgroundColor: C.bg,
        borderTopWidth: 1,
        borderTopColor: C.border,
        paddingVertical: S.sm,
        paddingHorizontal: S.sm
    },
    navItem: {flex: 1, alignItems: "center", paddingVertical: S.sm, borderRadius: R.md},
    navItemOn: {backgroundColor: C.accentSoft},
    navText: {color: C.muted, fontSize: 12, fontWeight: "700"},
    navTextOn: {color: C.accent, fontSize: 12, fontWeight: "700"},
    priority: {
        color: C.blue,
        backgroundColor: C.blueSoft,
        borderRadius: R.pill,
        paddingVertical: 2,
        paddingHorizontal: S.sm,
        fontSize: F.sm,
        fontWeight: "700"
    }
});
