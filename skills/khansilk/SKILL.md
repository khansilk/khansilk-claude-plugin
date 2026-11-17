---
name: khansilk
description: Use when the user mentions KhanSilk, an AI swarm, a KhanSilk job or project, or asks to open the KhanSilk Studio. Covers starting the session, opening the Studio inside Claude, watching and steering jobs, and staying inside the user's permissions and budget.
---

# Working with KhanSilk

KhanSilk runs budget-capped swarms of AI agents (Emperor, Generals, Captains, Soldiers) that build software and games.
Its tools for Claude come from the KhanSilk desktop app on the user's Windows PC (the `khansilk` MCP server it installs).

## First, check that KhanSilk is connected

If KhanSilk's tools (khansilk_session_start, khansilk_open_studio, list_jobs and others) aren't available in this
conversation, the desktop app isn't installed or isn't connected to Claude yet: follow the **install-khansilk** skill
and stop here.

## Start every KhanSilk task the same way

1. Call `khansilk_session_start` once. It returns the playbook, the user's standing decisions and your permissions.
2. For anything you are unsure about, call `khansilk_guide` (or `khansilk_should_ask`) instead of guessing.

## Open the Studio inside Claude

When the user says "open studio", "show KhanSilk" or similar, call `khansilk_open_studio`. Claude shows the real
KhanSilk Studio in the conversation. The page talks to the desktop app, so the app must be running:

- If it reports the app is not running, call `khansilk_launch_desktop`. If that says `not_installed`, use the
  **install-khansilk** skill.
- Inside the Studio you can use the `studio_*` tools (open a tab or panel, select a project, open a run, switch the
  hierarchy between tree and pyramid, point something out to the user).
- Requests from Claude act as an agent, never as the owner: owner-only actions such as the kill switch or granting
  permissions are refused. Tell the user to do those in the app.

## Watching and steering jobs

- `list_jobs`, `get_job_status`, `watch_job` and `get_spend` show what is running and what it costs.
- `pause_job`, `resume_job`, `steer` and the settings tools need permissions the owner granted. Never work around a
  missing permission: ask with `request_permissions` and tell the user why.
- Always forecast cost (`forecast_tumen_budget`, `settings_forecast`) before anything that spends money, and confirm
  expensive or irreversible actions with the user first.
