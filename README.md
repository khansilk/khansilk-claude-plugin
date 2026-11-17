# KhanSilk for Claude

Run, watch and steer [KhanSilk](https://khansilk.com) AI swarms from Claude, and open the KhanSilk Studio right
inside the conversation.

## Install

Find **KhanSilk** in Claude's plugin directory (https://claude.ai/directory) and add it. Then ask Claude for KhanSilk,
for example "open the KhanSilk studio".

## What you need

- Windows 10 or 11
- The free KhanSilk desktop app. If it isn't installed, just ask Claude for KhanSilk: it will offer to download the
  official installer from khansilk.com for you (only after you say yes), or tell you how to install it.

## What's inside

| Part | What it does |
|---|---|
| `mcpServers` in `.claude-plugin/plugin.json` + `scripts/khansilk-mcp.cmd` | Starts KhanSilk's MCP server from the installed desktop app (`khansilk-backend.exe --mcp`). |
| `scripts/install-helper.ps1` | Used only when KhanSilk isn't installed: a small helper with two tools, one that explains how to install and one that downloads and opens the official installer after you agree. |
| `skills/khansilk` | How Claude should work with KhanSilk: start a session, open the Studio, stay within your permissions and budget. |
| `skills/install-khansilk` | How Claude gets KhanSilk installed with your OK. |

## Privacy and safety

The plugin runs only on your computer. Claude talks to your local KhanSilk app; owner-only actions (the kill switch,
granting permissions, raising budgets) stay with you in the app. The install helper downloads only from
khansilk.com and never installs anything by itself: Windows shows you the normal installer window.

Support: support@khansilk.com (https://khansilk.com/contact) · Privacy policy: https://khansilk.com/privacy · Terms: https://khansilk.com/terms

© Jellyball LLC. KhanSilk and the KhanSilk logo are trademarks of Jellyball LLC.
