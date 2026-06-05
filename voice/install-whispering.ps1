# Whispering Voice Control installer for Corpify Pro tier (Windows)
# Whispering is open-source (MIT) by EpicenterHQ:
#   https://github.com/EpicenterHQ/epicenter

$ErrorActionPreference = 'Stop'

Write-Host ""
Write-Host "Installing Whispering (Voice Control)..." -ForegroundColor Cyan
Write-Host "Source: https://github.com/EpicenterHQ/epicenter (MIT license)"
Write-Host ""

# Try winget first (simplest if user has it)
$wingetAvailable = $null -ne (Get-Command winget -ErrorAction SilentlyContinue)

if ($wingetAvailable) {
    Write-Host "Trying winget install..."
    try {
        winget install --id EpicenterHQ.Whispering --silent --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
        Write-Host "[OK] Whispering installed via winget" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps for you:"
        Write-Host "  1. Open Whispering from Start Menu"
        Write-Host "  2. Settings → choose Whisper.cpp (local) as transcription provider"
        Write-Host "  3. Settings → set your push-to-talk hotkey"
        Write-Host "  4. Test: hold the hotkey, speak, release - text appears at cursor"
        Write-Host ""
        Write-Host "Full guide: ~/corpify/docs/11-voice-control/"
        exit 0
    } catch {
        Write-Host "winget install failed, falling back to GitHub release download" -ForegroundColor Yellow
    }
}

# Fallback: download latest release directly from GitHub
Write-Host "Downloading latest Whispering release from GitHub..."
$releasesApi = "https://api.github.com/repos/EpicenterHQ/epicenter/releases/latest"
try {
    $release = Invoke-RestMethod -Uri $releasesApi -TimeoutSec 20
    $asset = $release.assets | Where-Object { $_.name -like "*windows*x64*.msi" -or $_.name -like "*win*x64*.exe" -or $_.name -like "*Setup*.exe" } | Select-Object -First 1
    if (-not $asset) {
        $asset = $release.assets | Where-Object { $_.name -match "(\.msi|\.exe)$" } | Select-Object -First 1
    }
    if (-not $asset) {
        Write-Host "Could not find a Windows installer in latest release." -ForegroundColor Yellow
        Write-Host "Please install manually:"
        Write-Host "  $($release.html_url)"
        exit 0
    }

    $tmp = Join-Path $env:TEMP $asset.name
    Write-Host "  Downloading $($asset.name) ($([math]::Round($asset.size / 1MB, 1)) MB)..."
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $tmp -UseBasicParsing

    Write-Host "  Running installer (may prompt UAC)..."
    Start-Process -FilePath $tmp -Wait

    Write-Host "[OK] Whispering installed" -ForegroundColor Green
} catch {
    Write-Host "Could not auto-install Whispering: $_" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Manual install: visit https://epicenter.so/whispering/"
    Write-Host "Or: https://github.com/EpicenterHQ/epicenter/releases"
}

Write-Host ""
Write-Host "Full Voice Control guide: ~/corpify/docs/11-voice-control/"
