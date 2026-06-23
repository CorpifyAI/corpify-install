# Corpify Installer for Windows (PowerShell)
# Run with: irm https://corpify.tech/install.ps1 | iex

$ErrorActionPreference = 'Stop'

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CORPIFY - AI Corporation Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Welcome. This will install your AI Corporation."
Write-Host "Estimated time: 5-10 minutes."
Write-Host ""

# ---- Consent screen (legal + transparency) -------------------------------
Write-Host "Before we begin, please review what this installer will do on" -ForegroundColor Yellow
Write-Host "your computer:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. INSTALL THIRD-PARTY SOFTWARE (only if not already present),"
Write-Host "   via the official Windows Package Manager (winget):"
Write-Host "     - Git for Windows                 (license: GPL v2)"
Write-Host "     - Node.js LTS                      (license: MIT)"
Write-Host "     - Microsoft Visual Studio Code     (license: MIT)"
Write-Host "     - Claude Code CLI by Anthropic     (license: Anthropic Terms)"
Write-Host "     - Claude Code VS Code extension    (license: Anthropic Terms)"
Write-Host "     - Whispering by EpicenterHQ        (license: MIT) -- Pro only"
Write-Host "   winget auto-accepts each vendor's own license agreement."
Write-Host "   By proceeding you authorize these installations."
Write-Host ""
Write-Host "2. DOWNLOAD CORPIFY CONTENT:"
Write-Host "     - Agent definitions and guides into ~/corpify/"
Write-Host "     - License info into ~/.corpify/license.json"
Write-Host ""
Write-Host "3. STORE YOUR EMAIL LOCALLY:"
Write-Host "   The email tied to your license is saved in"
Write-Host "   ~/.corpify/license.json. This file stays on your computer."
Write-Host "   It is sent only to LemonSqueezy for license validation."
Write-Host ""
Write-Host "4. WHAT WE DO NOT DO:"
Write-Host "     - No kernel-level software"
Write-Host "     - No auto-start / background services"
Write-Host "     - No telemetry collection"
Write-Host "     - No registry or Windows-settings changes beyond what each"
Write-Host "       installed program does on its own"
Write-Host ""
Write-Host "You can remove everything later via Windows 'Apps & features'"
Write-Host "plus deleting ~/corpify/ and ~/.corpify/."
Write-Host ""
Write-Host "Full terms: https://corpify.tech/legal/installation.html"
Write-Host "Third-party licenses: see THIRD-PARTY-NOTICES.md in ~/corpify/"
Write-Host ""
$consent = Read-Host "Type 'agree' to continue, or anything else to cancel"
if ($consent.Trim().ToLower() -ne 'agree') {
    Write-Host ""
    Write-Host "Installation cancelled. Nothing was changed on your computer." -ForegroundColor Yellow
    exit 0
}
Write-Host ""

# ---- License key (taken from your install command; prompt only as fallback)
# Your personalized command sets $env:CORPIFY_KEY so you never have to paste
# the key into the console separately.
$licenseKey = "$env:CORPIFY_KEY" -replace '\s',''
if ($licenseKey.Length -ge 16) {
    Write-Host "License key detected from your install command." -ForegroundColor Green
} else {
    Write-Host "License key required (you received it by email after purchase)." -ForegroundColor Yellow
    Write-Host "Format: XXXXXXXX-XXXXXXXX-XXXXXXXX-XXXXXXXX"
    Write-Host ""
    $licenseKey = (Read-Host "Paste your license key") -replace '\s',''
}

if (-not $licenseKey -or $licenseKey.Length -lt 16) {
    Write-Host ""
    Write-Host "No license key entered." -ForegroundColor Red
    Write-Host "Purchase at: https://corpify.tech"
    exit 1
}

# ---- Validate via LemonSqueezy License API ------------------------------
Write-Host ""
Write-Host "Validating license..." -ForegroundColor Yellow

$response = $null
try {
    $response = Invoke-RestMethod -Method Post `
        -Uri "https://api.lemonsqueezy.com/v1/licenses/validate" `
        -Body @{ license_key = $licenseKey } `
        -ContentType "application/x-www-form-urlencoded" `
        -TimeoutSec 15
} catch {
    Write-Host "ERROR contacting license server: $_" -ForegroundColor Red
    Write-Host "Check your internet connection and try again."
    exit 1
}

if (-not $response.valid) {
    Write-Host ""
    Write-Host "License invalid: $($response.error)" -ForegroundColor Red
    Write-Host "If you purchased recently, check your email for the correct key."
    Write-Host "Support: support@corpify.tech"
    Write-Host "Purchase: https://corpify.tech"
    exit 1
}

# Tier from product name (robust across test/live), with product_id fallback
$productId = [int]$response.meta.product_id
$pname = "$($response.meta.product_name) $($response.meta.variant_name)"
if ($pname -match 'Pro' -or $productId -eq 1112833) {
    $tier = 'pro'
} else {
    $tier = 'standard'
}

Write-Host ""
Write-Host "License valid! Tier: $($tier.ToUpper())" -ForegroundColor Green
$customerEmail = $response.meta.customer_email
Write-Host "Activated for: $customerEmail"
Write-Host ""

# ---- Save license info locally -------------------------------------------
$corpifyDir = Join-Path $env:USERPROFILE ".corpify"
New-Item -ItemType Directory -Path $corpifyDir -Force | Out-Null

$licenseFile = Join-Path $corpifyDir "license.json"
@{
    key             = $licenseKey
    tier            = $tier
    product_id      = $productId
    instance_id     = $response.instance.id
    customer_email  = $customerEmail
    activated_at    = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
} | ConvertTo-Json | Set-Content -Path $licenseFile -Encoding UTF8

# ---- Prerequisites check -------------------------------------------------
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

function Test-Command($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

# Git
if (-not (Test-Command git)) {
    Write-Host "  Installing Git..." -ForegroundColor Yellow
    winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "  [OK] Git" -ForegroundColor Green
}

# Node.js
if (-not (Test-Command node)) {
    Write-Host "  Installing Node.js LTS..." -ForegroundColor Yellow
    winget install --id OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "  [OK] Node.js" -ForegroundColor Green
}

# VS Code
if (-not (Test-Command code)) {
    Write-Host "  Installing VS Code..." -ForegroundColor Yellow
    winget install --id Microsoft.VisualStudioCode -e --silent --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "  [OK] VS Code" -ForegroundColor Green
}

# Claude Code CLI (terminal) — always install/update to the LATEST version.
# Old versions had a login code-paste bug (fixed in v2.1.108), so we never skip.
Write-Host "  Installing / updating Claude Code (latest)..." -ForegroundColor Yellow
npm install -g @anthropic-ai/claude-code@latest 2>&1 | Out-Null
Write-Host "  [OK] Claude Code CLI (latest)" -ForegroundColor Green

# Claude Code VS Code extension (UI panel)
# On Windows, 'code' in PATH points to Code.exe (GUI). CLI lives in bin\code.cmd.
Write-Host "  Installing Claude Code VS Code extension..." -ForegroundColor Yellow
try {
    $codeExe = (Get-Command code -ErrorAction SilentlyContinue).Source
    if ($codeExe) {
        $codeCli = Join-Path (Split-Path -Parent $codeExe) 'bin\code.cmd'
        if (-not (Test-Path $codeCli)) { $codeCli = 'code.cmd' }
        & $codeCli --install-extension anthropic.claude-code --force 2>&1 | Out-Null
        Write-Host "  [OK] Claude Code VS Code extension" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] VS Code not detected. Extension skipped (install manually later)." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  [WARN] Extension install failed: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "         Install later from VS Code Extensions, search 'Claude Code'." -ForegroundColor DarkGray
}

# Remove GitHub Copilot so Claude Code is the ONLY AI chat icon in VS Code
# (customers were typing into Copilot by mistake — this prevents the confusion)
try {
    $cc2 = (Get-Command code -ErrorAction SilentlyContinue).Source
    if ($cc2) {
        $cli2 = Join-Path (Split-Path -Parent $cc2) 'bin\code.cmd'
        if (-not (Test-Path $cli2)) { $cli2 = 'code.cmd' }
        & $cli2 --uninstall-extension github.copilot-chat --force 2>&1 | Out-Null
        & $cli2 --uninstall-extension github.copilot --force 2>&1 | Out-Null
        Write-Host "  [OK] GitHub Copilot removed (Claude Code is your only AI panel)" -ForegroundColor Green
    }
} catch { }

# ---- Download Corpify content --------------------------------------------
Write-Host ""
Write-Host "Downloading Corpify content..." -ForegroundColor Yellow

$installDir = Join-Path $env:USERPROFILE "corpify"
if (Test-Path $installDir) {
    Write-Host "  Existing installation at $installDir" -ForegroundColor Yellow
    $confirm = Read-Host "  Overwrite? (yes/no)"
    if ($confirm -ne 'yes') {
        Write-Host "Cancelled."
        exit 0
    }
    Remove-Item -Recurse -Force $installDir
}

# Clone the public corpify-install repo
# Git writes progress info to stderr; with $ErrorActionPreference='Stop' that
# would abort the installer. Temporarily relax, restore after.
$prevEAP = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
git clone --depth 1 https://github.com/CorpifyAI/corpify-install.git $installDir 2>&1 | Out-Null
$gitExit = $LASTEXITCODE
$ErrorActionPreference = $prevEAP

if ($gitExit -ne 0 -or -not (Test-Path (Join-Path $installDir '.claude'))) {
    Write-Host "  Download failed (git exit code: $gitExit)." -ForegroundColor Red
    exit 1
}
Write-Host "  [OK] Downloaded to $installDir" -ForegroundColor Green

# ---- Tier gating (copy correct agents) -----------------------------------
# Native PowerShell — no Python dependency on Windows
Write-Host ""
Write-Host "Configuring for $tier tier..." -ForegroundColor Yellow

& powershell -NoProfile -ExecutionPolicy Bypass -File "$installDir\lib\tier_gate.ps1" -Tier $tier -InstallDir $installDir
if ($LASTEXITCODE -ne 0) {
    Write-Host "  Tier gating failed." -ForegroundColor Red
    exit 1
}

# ---- Pro: Voice Control --------------------------------------------------
if ($tier -eq 'pro') {
    Write-Host ""
    Write-Host "Installing Voice Control (Pro feature)..." -ForegroundColor Yellow
    & powershell -ExecutionPolicy Bypass -File "$installDir/voice/install-whispering.ps1"
}

# ---- Create the "Open Corpify" desktop shortcut (opens VS Code) ----------
try {
    $codeTarget = (Get-Command code -ErrorAction SilentlyContinue).Source
    $shortcutOk = $false
    if ($codeTarget) {
        $desktop = [Environment]::GetFolderPath("Desktop")
        $lnk = Join-Path $desktop "Open Corpify.lnk"
        $ws  = New-Object -ComObject WScript.Shell
        $sc  = $ws.CreateShortcut($lnk)
        $sc.TargetPath       = $codeTarget
        $sc.Arguments        = "`"$installDir`""
        $sc.WorkingDirectory = $installDir
        $sc.Description       = "Open your Corpify AI Corporation"
        $sc.Save()
        $shortcutOk = $true
    }
} catch { $shortcutOk = $false }

# ---- Done ----------------------------------------------------------------
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Your AI Corporation is ready at: $installDir"
if ($shortcutOk) {
    Write-Host "An 'Open Corpify' icon was added to your Desktop (opens your corporation)." -ForegroundColor Green
}
Write-Host ""
Write-Host "Opening VS Code with your corporation..."
Write-Host ""
Write-Host "WHAT TO DO IN VS CODE (one time):" -ForegroundColor Yellow
Write-Host "  1. If asked 'Do you trust the authors?' -> click 'Yes, I trust the authors'."
Write-Host "  2. On the LEFT toolbar, click the Claude Code icon (the starburst)."
Write-Host "     It is the ONLY AI chat - we removed GitHub Copilot to avoid confusion."
Write-Host "  3. Click 'Sign in' -> '1. Claude account with subscription' (your Claude Pro)."
Write-Host "  4. In the chat, type:  hi   -> your CEO greets you."
Write-Host "  Next time: just double-click the 'Open Corpify' icon on your Desktop."
Write-Host ""
Write-Host "Need help? support@corpify.tech"
Write-Host ""
Start-Sleep -Seconds 3
code $installDir
