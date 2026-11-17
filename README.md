# KhanSilk for Claude

Helps Claude work with [KhanSilk](https://khansilk.com), the app that runs budget-capped swarms of AI agents (an
Emperor, Generals, Captains and Soldiers) to plan, build, test and fix software and games while a ledger keeps every
cent under your cap.

## Install

Find **KhanSilk** in Claude's plugin directory (https://claude.ai/directory) and add it. Then ask Claude for KhanSilk,
for example "set up KhanSilk" or "open the KhanSilk studio".

## What it does

This plugin contains two skills, which are instructions for Claude. It runs nothing on your computer by itself.

| Skill | What Claude does with it |
|---|---|
| `install-khansilk` | Walks you through installing the free KhanSilk desktop app for Windows from khansilk.com and connecting it to Claude Code or the Claude desktop app. Claude only downloads the installer for you if you say yes, and you always click through the normal Windows installer. |
| `khansilk` | Once KhanSilk is connected: starts a session, opens the KhanSilk Studio in the chat, watches and steers your jobs, and stays within the permissions and budget you set. Owner-only actions (the kill switch, granting permissions, raising budgets) stay with you in the app. |

## What you need

- Windows 10 or 11
- The free KhanSilk desktop app: https://khansilk.com/download

KhanSilk's tools for Claude come from the installed desktop app and run on your own computer. Your projects stay
on your machine; AI providers you choose are billed by them, and KhanSilk credits are billed by KhanSilk.

Support: support@khansilk.com (https://khansilk.com/contact) · Privacy policy: https://khansilk.com/privacy · Terms: https://khansilk.com/terms

© Jellyball LLC. KhanSilk and the KhanSilk logo are trademarks of Jellyball LLC.
