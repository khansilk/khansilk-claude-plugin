---
name: install-khansilk
description: Use when the user wants KhanSilk but its tools (names starting with khansilk_, or list_jobs, launch_studio_job) aren't available in this conversation. Explains how to install the free KhanSilk desktop app for Windows and connect it to Claude, and helps with each step.
---

# Installing KhanSilk and connecting it to Claude

KhanSilk's tools come from its free desktop app for Windows. When those tools aren't available here, the app isn't
installed yet, or isn't connected to this Claude app. Help the user in this order, one step at a time, and ask before
doing anything on their computer.

## 1. Install the desktop app

1. Ask: "Do you want to install the KhanSilk desktop app? It's free, for Windows 10 or 11."
2. Give them the official download page: https://khansilk.com/download (choose Download for Windows).
3. They run the downloaded setup file (no admin rights needed) and open KhanSilk once.

If you have a terminal on their computer (for example in Claude Code) and they say yes, you may download
https://khansilk.com/download/windows to their Downloads folder and open it for them. Only from khansilk.com, only
after their yes in this conversation, and never install silently: they click through the normal installer.

On macOS or Linux, the desktop app isn't available yet: say so and point them to https://khansilk.com.

## 2. Connect KhanSilk to Claude

The installed app includes KhanSilk's tools for Claude. They run on the user's own computer.

**Claude Code** (the user runs this once in a terminal):

```
claude mcp add khansilk -- "%LOCALAPPDATA%\KhanSilk\khansilk-backend.exe" --mcp
```

(In PowerShell, write `$env:LOCALAPPDATA` instead of `%LOCALAPPDATA%`.)

**Claude desktop app**: the user fully quits Claude (tray icon, Quit), opens Settings, Developer, Edit config, and
adds this entry inside "mcpServers" (replacing YOUR-NAME with their Windows user folder name), then reopens Claude:

```json
"khansilk": {
  "command": "C:\\Users\\YOUR-NAME\\AppData\\Local\\KhanSilk\\khansilk-backend.exe",
  "args": ["--mcp", "--project-dir", "C:\\Users\\YOUR-NAME\\AppData\\Roaming\\app.khansilk.studio\\claude"]
}
```

Settings, Developer should then show khansilk as Running. Tell them to start a new chat and ask for KhanSilk.

## 3. Check it worked

In the new conversation, KhanSilk's tools appear (for example khansilk_session_start and khansilk_open_studio).
Then follow the **khansilk** skill.
