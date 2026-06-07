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

# ---- License key prompt --------------------------------------------------
Write-Host "License key required (you received it by email after purchase)." -ForegroundColor Yellow
Write-Host "Format: XXXXXXXX-XXXXXXXX-XXXXXXXX-XXXXXXXX"
Write-Host ""
$licenseKey = Read-Host "Paste your license key"

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

# Tier mapping (product IDs from LemonSqueezy)
$tierMap = @{
    1112829 = 'standard'
    1112833 = 'pro'
}
$productId = [int]$response.meta.product_id
$tier = $tierMap[$productId]
if (-not $tier) { $tier = 'standard' }

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

# Claude Code CLI (terminal)
if (-not (Test-Command claude)) {
    Write-Host "  Installing Claude Code CLI..." -ForegroundColor Yellow
    npm install -g @anthropic-ai/claude-code 2>&1 | Out-Null
} else {
    Write-Host "  [OK] Claude Code CLI" -ForegroundColor Green
}

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
Write-Host ""
Write-Host "Configuring for $tier tier..." -ForegroundColor Yellow

python "$installDir/lib/tier_gate.py" --tier $tier --install-dir $installDir

# ---- Pro: Voice Control --------------------------------------------------
if ($tier -eq 'pro') {
    Write-Host ""
    Write-Host "Installing Voice Control (Pro feature)..." -ForegroundColor Yellow
    & powershell -ExecutionPolicy Bypass -File "$installDir/voice/install-whispering.ps1"
}

# ---- Open VS Code with corporation ---------------------------------------
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Your AI Corporation is ready at: $installDir"
Write-Host ""
Write-Host "Opening VS Code with your corporation..."
Start-Sleep -Seconds 2
code $installDir

Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. In VS Code, click the Claude icon on the left sidebar"
Write-Host "  2. Sign in to Claude (browser will open, allow access)"
Write-Host "  3. In the chat, type: hi"
Write-Host "  4. The CEO will greet you and walk you through everything"
Write-Host ""
Write-Host "Need help? See ~/corpify/docs/faq/"
Write-Host "Support: support@corpify.tech"
Write-Host ""
