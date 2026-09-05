#!/usr/bin/env pwsh
# --------------------------------------------------
# scripts/bootstrap/windows.ps1
#
# Purpose
#   Bootstrap the Windows host side of the development environment from
#   this repository. Idempotent. Re-running should not break things.
#
# Assumes WSL2 is already installed (see docs/migration/windows-arrival-checklist.md).
# This script handles the Windows host only — WSL2-side setup is separate.
#
# Usage
#   pwsh scripts/bootstrap/windows.ps1                # default safe mode
#   pwsh scripts/bootstrap/windows.ps1 -SkipWinget    # symlinks only
#   pwsh scripts/bootstrap/windows.ps1 -DryRun        # preview, no changes
#   pwsh scripts/bootstrap/windows.ps1 -Force         # back up + overwrite
#                                                   # existing real files
#
# Side effects
#   - Installs winget packages from platforms/windows/packages.txt (if present)
#   - Creates PowerShell profile symlink
#   - Symlinks ~/.gitconfig, ~/.gitignore_global, ~/.gitconfig.local,
#     and VS Code user settings + keybindings
#   - Does NOT install WSL2 or WSL-side tooling
#
# Safety
#   By default, an existing non-symlink file at the destination causes
#   that link to be SKIPPED. Use -Force to back up the existing file
#   to <link>.backup-<UTC timestamp> and replace it. Use -DryRun to see
#   what would happen without making any changes.
# --------------------------------------------------

[CmdletBinding()]
param(
    [switch]$SkipWinget,
    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot  = Resolve-Path "$ScriptDir/../.."
$PlatformsDir = Join-Path $RepoRoot 'platforms\windows'

Write-Host "==> MY-DEV-ENVIRONMENT Windows bootstrap"
Write-Host "    repo: $RepoRoot"
if ($DryRun) { Write-Host "    MODE: dry-run (no changes)" }
if ($Force)  { Write-Host "    MODE: force (existing files backed up + replaced)" }

# --------------------------------------------------
# Developer Mode check (informational, not blocking)
# --------------------------------------------------
$devKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'
$developerMode = (Get-ItemProperty -Path $devKey -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense
if ($developerMode -ne 1) {
    Write-Warning "Developer Mode is not enabled. Symlink creation may fail unless run as Administrator."
}

# --------------------------------------------------
# winget
# --------------------------------------------------
if (-not $SkipWinget) {
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $winget) {
        Write-Warning "winget is not available. Install App Installer from Microsoft Store or skip with -SkipWinget."
    } else {
        $packagesFile = Join-Path $PlatformsDir 'packages.txt'
        if (Test-Path $packagesFile) {
            Write-Host "==> winget import: $packagesFile"
            if ($DryRun) {
                Write-Host "    would run: winget import -i $packagesFile --ignore-versions --accept-source-agreements --accept-package-agreements"
            } else {
                winget import -i $packagesFile --ignore-versions --accept-source-agreements --accept-package-agreements
            }
        } else {
            Write-Host "==> no platforms/windows/packages.txt yet; skipping winget import"
            Write-Host "    generate one with: winget export -o platforms\windows\packages.txt"
        }
    }
} else {
    Write-Host "==> skipping winget (-SkipWinget)"
}

# --------------------------------------------------
# Symlink helper
# Default: existing real file → SKIP. Existing symlink → replace.
# -Force: existing real file → back up + replace. -DryRun: no changes.
# --------------------------------------------------
function New-Symlink {
    param([string]$Target, [string]$Link)
    if (Test-Path $Link) {
        $item = Get-Item $Link
        if ($item.LinkType -eq 'SymbolicLink') {
            if ($DryRun) {
                Write-Host "    would replace existing symlink: $Link"
            } else {
                New-Item -ItemType SymbolicLink -Path $Link -Target $Target -Force | Out-Null
                Write-Host "    linked: $Link -> $Target"
            }
            return
        }
        if (-not $Force) {
            Write-Warning "SKIP: $Link exists and is not a symlink. Pass -Force to back up and replace."
            return
        }
        $backup = "$Link.backup-$((Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ'))"
        Write-Warning "BACKUP: $Link -> $backup (then link)"
        if ($DryRun) {
            Write-Host "    would run: Move-Item $Link $backup; New-Item SymbolicLink $Link $Target"
            return
        }
        Move-Item -Path $Link -Destination $backup -Force
    }
    if ($DryRun) {
        Write-Host "    would create: $Link -> $Target"
        return
    }
    New-Item -ItemType SymbolicLink -Path $Link -Target $Target -Force | Out-Null
    Write-Host "    linked: $Link -> $Target"
}

# --------------------------------------------------
# Git config (host-side)
# --------------------------------------------------
Write-Host "==> Git for Windows symlinks"
New-Symlink `
    -Target (Join-Path $RepoRoot 'configs\git\gitconfig') `
    -Link    (Join-Path $env:USERPROFILE '.gitconfig')
New-Symlink `
    -Target (Join-Path $RepoRoot 'configs\git\gitignore_global') `
    -Link    (Join-Path $env:USERPROFILE '.gitignore_global')
New-Symlink `
    -Target (Join-Path $RepoRoot 'configs\git\gitconfig.windows-host') `
    -Link    (Join-Path $env:USERPROFILE '.gitconfig.local')

# --------------------------------------------------
# PowerShell profile
# --------------------------------------------------
Write-Host "==> PowerShell profile"
$profileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path $profileDir)) {
    if (-not $DryRun) {
        New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
    }
}
New-Symlink `
    -Target (Join-Path $RepoRoot 'configs\windows\powershell\profile.ps1') `
    -Link    $PROFILE

# --------------------------------------------------
# VS Code (Windows-side)
# --------------------------------------------------
Write-Host "==> VS Code (Windows host)"
$vscodeUser = Join-Path $env:APPDATA 'Code\User'
if (-not (Test-Path $vscodeUser)) {
    if (-not $DryRun) {
        New-Item -ItemType Directory -Force -Path $vscodeUser | Out-Null
    }
}
New-Symlink `
    -Target (Join-Path $RepoRoot 'configs\vscode\settings.json') `
    -Link    (Join-Path $vscodeUser 'settings.json')
New-Symlink `
    -Target (Join-Path $RepoRoot 'configs\vscode\keybindings.json') `
    -Link    (Join-Path $vscodeUser 'keybindings.json')

# --------------------------------------------------
# Done
# --------------------------------------------------
Write-Host "==> done."