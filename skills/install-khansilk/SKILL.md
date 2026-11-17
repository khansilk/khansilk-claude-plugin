---
name: install-khansilk
description: Use when the user wants KhanSilk but the KhanSilk desktop app is not installed (the only KhanSilk tools are khansilk_install_status and khansilk_download_installer, or khansilk_launch_desktop says not_installed). Downloads the official installer with the user's OK, or gives them the steps.
---

# Installing KhanSilk

KhanSilk's tools come from its free desktop app for Windows. Until it is installed, this plugin only offers
`khansilk_install_status` and `khansilk_download_installer`.

1. Call `khansilk_install_status` and tell the user in one or two sentences that KhanSilk needs its desktop app.
2. Ask: "Do you want me to download and open the KhanSilk installer from khansilk.com?"
3. **If they say yes**, call `khansilk_download_installer` with `user_confirmed: true`. It saves
   `KhanSilk-setup.exe` to their Downloads folder and opens it. Tell them to click through the installer, open
   KhanSilk once, then fully quit and reopen Claude (from the tray icon, not just the window) so the tools appear.
4. **If they say no, or the download fails**, give them the steps:
   1. Go to https://khansilk.com/download and choose Download for Windows.
   2. Run the downloaded setup file (no admin rights needed).
   3. Open KhanSilk once, then fully quit and reopen Claude.
5. Never download or run anything without the user's yes in this conversation, and never install it silently.

On macOS or Linux, KhanSilk's desktop app isn't available yet: say so and point them to https://khansilk.com.

If you have a shell (for example in Claude Code) and the user prefers, you may instead download
https://khansilk.com/download/windows to their Downloads folder and open it, after the same yes.
