# KhanSilk for Claude: install helper (a tiny MCP server over stdio).
# Runs only when the KhanSilk desktop app is not installed. It offers two tools:
#   khansilk_install_status      - says KhanSilk isn't installed and how to install it
#   khansilk_download_installer  - downloads the official Windows installer from khansilk.com and opens it,
#                                  only after the user said yes (Windows then shows the normal installer window)
# stdout carries only MCP (JSON-RPC) messages, one per line.
$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)
$stdin = New-Object System.IO.StreamReader([Console]::OpenStandardInput(), $utf8)
$stdout = New-Object System.IO.StreamWriter([Console]::OpenStandardOutput(), $utf8)
$stdout.AutoFlush = $true

$Version = '0.1.0'
$DownloadPage = 'https://khansilk.com/download'
$InstallerUrl = 'https://khansilk.com/download/windows'
$IconSvg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024"><title>KhanSilk</title><rect width="1024" height="1024" rx="224" fill="#f4efe4"/><path fill="#16181d" transform="translate(244.9 212.0) scale(0.42735)" d="M300 0V1400H0V0ZM1038 0 1250 212 760 702 1250 1192 1038 1404 336 702Z"/></svg>'
$IconUri = 'data:image/svg+xml;base64,' + [Convert]::ToBase64String($utf8.GetBytes($IconSvg))

$Steps = @(
  "Open $DownloadPage and choose Download for Windows.",
  'Run the downloaded KhanSilk setup file and follow the installer (no admin rights needed).',
  'Open KhanSilk once, then fully quit and reopen Claude so it connects to the installed app.'
)

function Send($obj) { $stdout.WriteLine(($obj | ConvertTo-Json -Depth 20 -Compress)) }
function Reply($id, $result) { Send ([ordered]@{ jsonrpc = '2.0'; id = $id; result = $result }) }
function Fail($id, $code, $message) { Send ([ordered]@{ jsonrpc = '2.0'; id = $id; error = [ordered]@{ code = $code; message = $message } }) }
function TextResult($data, [bool]$isError = $false) {
  [ordered]@{ content = @([ordered]@{ type = 'text'; text = ($data | ConvertTo-Json -Depth 10) }); isError = $isError }
}

$Tools = @(
  [ordered]@{
    name = 'khansilk_install_status'
    title = 'Is KhanSilk installed?'
    description = 'KhanSilk''s desktop app is not installed on this computer, so its swarm and Studio tools are not available yet. Returns the download page and the install steps. Call this whenever the user asks for anything KhanSilk; then offer to download the installer with khansilk_download_installer, or give the user the steps.'
    inputSchema = [ordered]@{ type = 'object'; properties = [ordered]@{}; additionalProperties = $false }
    annotations = [ordered]@{ readOnlyHint = $true; openWorldHint = $false }
  },
  [ordered]@{
    name = 'khansilk_download_installer'
    title = 'Download the KhanSilk installer'
    description = 'Downloads the official KhanSilk installer for Windows from khansilk.com into the user''s Downloads folder and opens it, so Windows shows the normal installer window. ONLY call this after the user clearly said yes to downloading and installing KhanSilk in this conversation; pass user_confirmed=true. Nothing is installed until the user clicks through the installer.'
    inputSchema = [ordered]@{
      type = 'object'
      properties = [ordered]@{
        user_confirmed = [ordered]@{ type = 'boolean'; description = 'True only if the user said yes to downloading and installing KhanSilk.' }
        open_installer = [ordered]@{ type = 'boolean'; description = 'Open the installer after downloading (default true). False only downloads it.'; default = $true }
      }
      required = @('user_confirmed')
      additionalProperties = $false
    }
    annotations = [ordered]@{ readOnlyHint = $false; destructiveHint = $false; openWorldHint = $true }
  }
)

function Status {
  [ordered]@{
    installed = $false
    platform = 'windows'
    download_page = $DownloadPage
    windows_installer = $InstallerUrl
    steps = $Steps
    can_download_for_user = $true
    note = 'Ask the user before downloading. After installing, Claude must be fully quit and reopened to connect.'
  }
}

function DownloadInstaller($arguments) {
  if (-not $arguments -or $arguments.user_confirmed -ne $true) {
    return TextResult ([ordered]@{ downloaded = $false; reason = 'needs_user_confirmation'; ask_user = 'Download and install the KhanSilk desktop app from khansilk.com?'; steps = $Steps }) $true
  }
  $open = $true
  if ($null -ne $arguments.open_installer) { $open = [bool]$arguments.open_installer }
  $downloads = Join-Path $env:USERPROFILE 'Downloads'
  if (-not (Test-Path -LiteralPath $downloads)) { New-Item -ItemType Directory -Path $downloads | Out-Null }
  $target = Join-Path $downloads 'KhanSilk-setup.exe'
  try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $ProgressPreference = 'SilentlyContinue'
    $response = Invoke-WebRequest -Uri $InstallerUrl -OutFile $target -UseBasicParsing -MaximumRedirection 5 -PassThru
    $finalUrl = $null
    try { $finalUrl = [string]$response.BaseResponse.ResponseUri } catch { }
    $head = [IO.File]::ReadAllBytes($target)[0..1]
    if ($head.Count -lt 2 -or $head[0] -ne 0x4D -or $head[1] -ne 0x5A) {
      Remove-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
      return TextResult ([ordered]@{ downloaded = $false; reason = 'not_an_installer'; download_page = $DownloadPage; steps = $Steps }) $true
    }
    $hash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash
    if ($open) { Start-Process -FilePath $target | Out-Null }
    return TextResult ([ordered]@{
      downloaded = $true; path = $target; sha256 = $hash; from = $InstallerUrl; final_url = $finalUrl; opened = $open
      next = 'Tell the user to click through the KhanSilk installer, open KhanSilk once, then fully quit and reopen Claude.'
    })
  } catch {
    return TextResult ([ordered]@{ downloaded = $false; reason = 'download_failed'; detail = $_.Exception.Message; download_page = $DownloadPage; steps = $Steps }) $true
  }
}

while ($true) {
  $line = $stdin.ReadLine()
  if ($null -eq $line) { break }
  if (-not $line.Trim()) { continue }
  try { $msg = $line | ConvertFrom-Json } catch { Fail $null -32700 'Parse error'; continue }
  $hasId = $msg.PSObject.Properties.Name -contains 'id'
  if (-not $hasId) { continue }   # notifications need no reply
  $id = $msg.id
  switch ([string]$msg.method) {
    'initialize' {
      $pv = '2025-06-18'
      if ($msg.params -and $msg.params.protocolVersion) { $pv = [string]$msg.params.protocolVersion }
      Reply $id ([ordered]@{
        protocolVersion = $pv
        capabilities = [ordered]@{ tools = [ordered]@{ listChanged = $false } }
        serverInfo = [ordered]@{ name = 'khansilk'; title = 'KhanSilk'; version = $Version; websiteUrl = 'https://khansilk.com'; icons = @([ordered]@{ src = $IconUri; mimeType = 'image/svg+xml'; sizes = @('any') }) }
        instructions = 'The KhanSilk desktop app is not installed on this computer yet. When the user asks for KhanSilk, call khansilk_install_status, then offer to download the installer (khansilk_download_installer, only after the user says yes) or give them the steps.'
      })
    }
    'ping' { Reply $id ([ordered]@{}) }
    'tools/list' { Reply $id ([ordered]@{ tools = $Tools }) }
    'tools/call' {
      $name = [string]$msg.params.name
      if ($name -eq 'khansilk_install_status') { Reply $id (TextResult (Status)) }
      elseif ($name -eq 'khansilk_download_installer') { Reply $id (DownloadInstaller $msg.params.arguments) }
      else { Fail $id -32602 "Unknown tool: $name" }
    }
    'resources/list' { Reply $id ([ordered]@{ resources = @() }) }
    'prompts/list' { Reply $id ([ordered]@{ prompts = @() }) }
    default { Fail $id -32601 "Method not found: $($msg.method)" }
  }
}
