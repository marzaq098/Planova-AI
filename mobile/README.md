# Planova AI Mobile

Frontend-only MobUI app. It uses `@jac/mobui` primitives and the shared `store.jac` contract. No walkers or mock AI live here.

## Run

```bash
jac install
jac run --dev --no-cache --platform web mobile
```

Use this instead of the web command, not at the same time. Tasks, plans, and sessions stay empty until `store.jac` is connected to the backend.

Native (after one-time Expo setup):

```bash
jac setup mobile
jac run --dev mobile
```
