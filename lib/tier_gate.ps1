# Copy correct agent subset to user's installation based on tier.
#
# Standard: ~40 agents (all corp-*, meeting/management/debate, base engineering+testing)
# Pro:      ~52 agents (Standard + 12 Pro-only agents) + Voice Control flag
#
# PowerShell-native — no Python dependency, runs on every fresh Windows.

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('standard', 'pro')]
    [string]$Tier,

    [Parameter(Mandatory = $true)]
    [string]$InstallDir
)

$ErrorActionPreference = 'Stop'

$installPath = (Resolve-Path -Path $InstallDir).Path
$tierFile    = Join-Path $installPath "tiers\$Tier.json"
$agentsDir   = Join-Path $installPath '.claude\agents'

if (-not (Test-Path $tierFile)) {
    Write-Error "tier file not found: $tierFile"
    exit 1
}
if (-not (Test-Path $agentsDir)) {
    Write-Error "agents dir not found: $agentsDir"
    exit 1
}

$config       = Get-Content -Raw -Path $tierFile -Encoding UTF8 | ConvertFrom-Json
$allowed      = @{}
foreach ($name in $config.agents) { $allowed[$name] = $true }
$voiceEnabled = [bool]$config.voice_control

$kept    = 0
$removed = 0
Get-ChildItem -Path $agentsDir -Filter '*.md' -File | ForEach-Object {
    if ($allowed.ContainsKey($_.BaseName)) {
        $kept++
    } else {
        Remove-Item -Path $_.FullName -Force
        $removed++
    }
}

Write-Host "[tier_gate] Tier: $Tier"
Write-Host "[tier_gate] Kept $kept agents, removed $removed"

if ($Tier -eq 'pro' -and -not $voiceEnabled) {
    Write-Warning "[tier_gate] Pro tier without voice_control flag in tier JSON"
}

# Write marker file other tools can introspect
$marker = Join-Path $installPath '.corpify-tier'
Set-Content -Path $marker -Value $Tier -Encoding UTF8 -NoNewline
