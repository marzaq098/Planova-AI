# Planova backend

`api.jac` contains the graph models and public walkers. The frontend imports
these walkers through `store.jac`; Jac also exposes each `walker:pub` as a
JSON `POST /walker/<walker_name>` endpoint. The root `jac.toml` configures the
combined web app, Jac graph persistence, and ByLLM's Anthropic model.

## Run

From the repository root, start the Jac service for local development:

```bash
jac check .
jac run --dev
```

Jac serves the UI and its walker RPC endpoints from the same origin. In
production, deploy this Jac app to a reachable Jac host and open the URL that
host provides; the UI does not call a hard-coded localhost address.

Set `ANTHROPIC_API_KEY` in the process environment to enable Claude's plan
rationale. The scheduler remains deterministic and runs without the key.

## Walkers

| Walker | Purpose |
| --- | --- |
| `health` | Service health response |
| `list_tasks` | Read graph tasks |
| `add_task` | Validate and persist a task |
| `update_task` | Update a task |
| `set_task_status` | Complete or reopen a task |
| `delete_task` | Delete a task and its sessions |
| `list_sessions` | Read saved study sessions |
| `set_session_status` | Complete, reopen, or mark a session missed |
| `generate_study_plan` | Build and persist a deadline ordered, hour capped plan |
| `replan_missed_sessions` | Rebuild pending work within the saved daily hour limit |

For example, task creation is `POST /walker/add_task` with `title`,
`description`, `deadline`, `priority`, and `estimated_hours`. Planning is
`POST /walker/generate_study_plan` with `prompt` and `hours_per_day`.

The PowerShell CLI calls the same endpoints. Set the deployed Jac URL in
`PLANOVA_API_URL`, or pass `-BaseUrl` to an individual command:

```powershell
$env:PLANOVA_API_URL = "https://your-deployed-jac-host"
.\backend\planova.ps1 -Action list_tasks
```
