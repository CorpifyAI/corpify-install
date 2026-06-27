# Corpify Uninstaller for Windows (PowerShell)
# Run with:  irm https://corpify.tech/uninstall.ps1 | iex
# Preview (no changes):  powershell -ExecutionPolicy Bypass -File uninstall.ps1 -DryRun
#
# Mirrors install.ps1. Idempotent: safe to run on a partial/broken install.

param([switch]$DryRun)

# Idempotency over abort: a missing item must not stop the whole uninstall.
$ErrorActionPreference = 'Continue'

# ---- Report accumulator --------------------------------------------------
$script:report = [System.Collections.Generic.List[string]]::new()
function Add-Report($line) { $script:report.Add($line) | Out-Null }

# ---- Helpers -------------------------------------------------------------
function Confirm-Action($question) {
    $ans = Read-Host "$question (y/n)"
    return ($ans.Trim().ToLower() -in @('y', 'yes'))
}

# Idempotent delete: missing path -> note and continue, never throw.
function Remove-IfExists($path, $label) {
    if (Test-Path $path) {
        if ($DryRun) {
            Add-Report "[would remove] $label"
        } else {
            try {
                Remove-Item -Recurse -Force $path -ErrorAction Stop
                Add-Report "[removed] $label"
            } catch {
                Add-Report "[ERROR] could not remove $label : $($_.Exception.Message)"
            }
        }
    } else {
        Add-Report "[not found] $label"
    }
}

# Run a command (winget/npm/code) safely; never abort the script.
function Invoke-Safe($scriptblock, $label) {
    if ($DryRun) { Add-Report "[would run] $label"; return }
    try {
        $global:LASTEXITCODE = 0
        & $scriptblock 2>&1 | Out-Null
        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
            Add-Report "[ERROR] $label (exit code $LASTEXITCODE)"
        } else {
            Add-Report "[done] $label"
        }
    } catch {
        Add-Report "[ERROR] $label : $($_.Exception.Message)"
    }
}

# ---- Banner --------------------------------------------------------------
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CORPIFY - Uninstaller" -ForegroundColor Cyan
if ($DryRun) { Write-Host "  (DRY RUN - nothing will be changed)" -ForegroundColor Yellow }
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ---- Consent (transparency, mirror of installer) -------------------------
Write-Host "This will remove Corpify from your computer:" -ForegroundColor Yellow
Write-Host "  - Your corporation folder (~\corpify) and license (~\.corpify)"
Write-Host "  - The 'Open Corpify' desktop shortcut"
Write-Host "  - Optionally: deactivate your license, and remove third-party tools"
Write-Host "    (Git, Node, VS Code, Claude Code) - you will be asked for each one."
Write-Host ""
Write-Host "It will NOT remove anything not installed by Corpify."
Write-Host "Your corporation's memory can be backed up first (you will be asked)."
Write-Host ""
Write-Host "IMPORTANT: Close VS Code and any terminal using Corpify first -" -ForegroundColor Yellow
Write-Host "otherwise the corporation folder stays locked and cannot be deleted." -ForegroundColor Yellow
Write-Host ""
$consent = Read-Host "Type 'remove' to continue, or anything else to cancel"
if ($consent.Trim().ToLower() -ne 'remove') {
    Write-Host ""
    Write-Host "Cancelled. Nothing was changed on your computer." -ForegroundColor Yellow
    exit 0
}
Write-Host ""

# ---- Read license info (if present) --------------------------------------
$licenseFile = Join-Path $env:USERPROFILE ".corpify\license.json"
$lic = $null
if (Test-Path $licenseFile) {
    try {
        $lic = Get-Content $licenseFile -Raw | ConvertFrom-Json
        Write-Host "Found license for: $($lic.customer_email)" -ForegroundColor Green
    } catch {
        Write-Host "License file present but unreadable - license steps will be skipped." -ForegroundColor Yellow
    }
} else {
    Write-Host "No license file found - skipping license deactivation." -ForegroundColor DarkGray
}
Write-Host ""

# ---- License deactivation (free up the activation slot) ------------------
# Note: only possible if the install created an activation instance. Current
# installer uses /validate (no instance), so instance_id is usually null —
# in that case there is no activation slot to free; we say so and move on.
if ($lic -and $lic.key) {
    if (-not $lic.instance_id) {
        Add-Report "[note] license has no activation instance (nothing to deactivate)"
    }
    elseif (Confirm-Action "Release the license so you can install on another computer?") {
        if ($DryRun) {
            Add-Report "[would deactivate] license on LemonSqueezy"
        } else {
            try {
                $resp = Invoke-RestMethod -Method Post `
                    -Uri "https://api.lemonsqueezy.com/v1/licenses/deactivate" `
                    -Body @{ license_key = $lic.key; instance_id = $lic.instance_id } `
                    -ContentType "application/x-www-form-urlencoded" `
                    -TimeoutSec 15
                if ($resp.deactivated) {
                    Add-Report "[done] license deactivated (activation slot freed)"
                } else {
                    Add-Report "[note] license not deactivated: $($resp.error) - release later at corpify.tech"
                }
            } catch {
                Add-Report "[note] could not reach license server (offline?) - release later at corpify.tech or email support@corpify.tech"
            }
        }
    } else {
        Add-Report "[kept] license activation (not released)"
    }
}

# ---- Data protection: offer memory backup before deleting ----------------
$memPath = Join-Path $env:USERPROFILE "corpify\.claude\memory"
if (Test-Path $memPath) {
    Write-Host "Your corporation's memory holds its accumulated work (agent memory, projects)." -ForegroundColor Yellow
    if (Confirm-Action "Back up the memory before deleting?") {
        $backup = Join-Path $env:USERPROFILE ("corpify-memory-backup-" + (Get-Date -Format "yyyy-MM-dd"))
        if ($DryRun) {
            Add-Report "[would back up] memory -> $backup"
        } else {
            try {
                Copy-Item -Recurse -Force $memPath $backup -ErrorAction Stop
                Add-Report "[backed up] memory -> $backup"
            } catch {
                Add-Report "[ERROR] memory backup failed: $($_.Exception.Message)"
            }
        }
    }
}

# ---- Remove Corpify files (explicit confirmation; always-remove tier) -----
$doDelete = $DryRun -or (Confirm-Action "Delete your Corpify corporation and all its data?")
if ($doDelete) {
    Remove-IfExists (Join-Path $env:USERPROFILE "corpify") "corporation folder (~\corpify)"
    Remove-IfExists (Join-Path $env:USERPROFILE ".corpify") "license folder (~\.corpify)"
    $shortcut = Join-Path ([Environment]::GetFolderPath("Desktop")) "Open Corpify.lnk"
    Remove-IfExists $shortcut "desktop shortcut (Open Corpify)"
    # If the folder is still there, it was almost certainly locked by an open app.
    if (-not $DryRun -and (Test-Path (Join-Path $env:USERPROFILE "corpify"))) {
        Add-Report "[ACTION NEEDED] ~\corpify is still here - close VS Code / terminals using it, then run the uninstaller again"
    }
} else {
    Add-Report "[kept] Corpify files (deletion declined)"
}

# ---- Optional: third-party tools (ask per item; default keep) ------------
Write-Host ""
Write-Host "Corpify installed these only if they were missing. They are useful on" -ForegroundColor Yellow
Write-Host "their own - keep them unless you are sure you want them gone." -ForegroundColor Yellow
Write-Host ""

$codeCmd = (Get-Command code -ErrorAction SilentlyContinue).Source
# On Windows 'code' in PATH is Code.exe (GUI). The real CLI is bin\code.cmd.
$script:codeCli = $null
if ($codeCmd) {
    $script:codeCli = Join-Path (Split-Path -Parent $codeCmd) 'bin\code.cmd'
    if (-not (Test-Path $script:codeCli)) { $script:codeCli = 'code.cmd' }
}

# Claude Code CLI (npm global)
if (Get-Command claude -ErrorAction SilentlyContinue) {
    if (Confirm-Action "Remove Claude Code CLI (npm global)?") {
        Invoke-Safe { npm uninstall -g '@anthropic-ai/claude-code' } "remove Claude Code CLI"
    } else { Add-Report "[kept] Claude Code CLI" }
}

# Claude Code VS Code extension
if ($codeCmd) {
    if (Confirm-Action "Remove the Claude Code VS Code extension?") {
        Invoke-Safe { & $script:codeCli --uninstall-extension anthropic.claude-code --force } "remove Claude Code extension"
    } else { Add-Report "[kept] Claude Code extension" }
}

# Whispering (Pro voice control)
$hasWhisper = winget list --id EpicenterHQ.Whispering 2>$null | Select-String 'EpicenterHQ.Whispering'
if ($hasWhisper) {
    if (Confirm-Action "Remove Whispering (Pro voice control)?") {
        Invoke-Safe { winget uninstall --id EpicenterHQ.Whispering --silent } "remove Whispering"
    } else { Add-Report "[kept] Whispering" }
}

# Git / Node / VS Code (offer only if present)
if (Get-Command git -ErrorAction SilentlyContinue) {
    if (Confirm-Action "Remove Git for Windows?") {
        Invoke-Safe { winget uninstall --id Git.Git --silent } "remove Git"
    } else { Add-Report "[kept] Git" }
}
if (Get-Command node -ErrorAction SilentlyContinue) {
    if (Confirm-Action "Remove Node.js?") {
        Invoke-Safe { winget uninstall --id OpenJS.NodeJS.LTS --silent } "remove Node.js"
    } else { Add-Report "[kept] Node.js" }
}
if ($codeCmd) {
    if (Confirm-Action "Remove Visual Studio Code?") {
        Invoke-Safe { winget uninstall --id Microsoft.VisualStudioCode --silent } "remove VS Code"
    } else { Add-Report "[kept] VS Code" }
}

# Restore GitHub Copilot (the installer had removed it)
if ($codeCmd) {
    if (Confirm-Action "Restore GitHub Copilot that the installer removed?") {
        Invoke-Safe { & $script:codeCli --install-extension github.copilot --force } "restore GitHub Copilot"
        Invoke-Safe { & $script:codeCli --install-extension github.copilot-chat --force } "restore GitHub Copilot Chat"
    }
}

# ---- Report --------------------------------------------------------------
Write-Host ""
Write-Host "=== Uninstall report ===" -ForegroundColor Cyan
foreach ($line in $script:report) { Write-Host "  $line" }
Write-Host ""
if ($DryRun) {
    Write-Host "Dry run complete - no changes were made." -ForegroundColor Yellow
} else {
    Write-Host "Corpify has been uninstalled. Thank you." -ForegroundColor Green
}
Write-Host ""
