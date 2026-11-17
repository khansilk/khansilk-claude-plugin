@echo off
rem KhanSilk for Claude: starts KhanSilk's MCP server from the installed desktop app.
rem If the app is not installed, starts a small helper that can download the installer (with the user's OK)
rem or explain how to install it. stdout carries only MCP messages, so nothing here may print.
setlocal
set "KS_EXE=%LOCALAPPDATA%\KhanSilk\khansilk-backend.exe"
if defined KHANSILK_BACKEND_EXE set "KS_EXE=%KHANSILK_BACKEND_EXE%"
set "KS_HOME=%APPDATA%\app.khansilk.studio\claude"
if not exist "%KS_HOME%" mkdir "%KS_HOME%" >nul 2>&1
cd /d "%KS_HOME%" 2>nul || cd /d "%USERPROFILE%"
if exist "%KS_EXE%" (
  "%KS_EXE%" --mcp --project-dir "%KS_HOME%"
  exit /b
)
where khansilk >nul 2>&1 && (
  khansilk mcp
  exit /b
)
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-helper.ps1"
exit /b %ERRORLEVEL%
