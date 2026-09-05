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
#   pwsh scripts/bootstrap/windows.ps1
#   pwsh scripts/bootstrap/windows.ps1 -SkipWinget
#
# Side effects
#   - Installs winget packages from platforms/windows/packages.txt (if present)
#   - Creates PowerShell profile symlink
#   - Symlinks ~/.gitconfig + ~/.gitignore_global
#   - Does NOT install WSL2 or WSL-side tooling
# --------------------------------------------------

[CmdletBinding()]
param(
    [switch]$SkipWinget,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot  = Resolve-Path "$ScriptDir/../.."
$PlatformsDir = Join-Path $RepoRoot 'platforms\windows'

Write-Host "==> MY-DEV-ENVIRONMENT Windows bootstrap"
Write-Host "    repo: $RepoRoot"

# --------------------------------------------------
# Developer Mode check (needed for non-admin symlinks)
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
            winget import -i $packagesFile --ignore-versions --accept-source-agreements --accept-package-agreements
        } else {
            Write-Host "==> no platforms/windows/packages.txt yet; skipping winget import"
            Write-Host "    generate one with: winget export -o platforms\windows\packages.txt"
        }
    }
}

# --------------------------------------------------
# Helper
# --------------------------------------------------
function New-SymlinkIfMissing {
    param([string]$Target, [string]$Link)
    if (Test-Path $Link) {
        $item = Get-Item $Link
        if ($item.LinkType -eq 'SymbolicLink') {
            Write-Host "    ok (symlink): $Link"
            return
        }
        if (-not $Force) {
            Write-Warning "SKIP: $Link exists and is not a symlink. Pass -Force to back up and replace."
            return
        }
        $backup = "$Link.backup-$((Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ'))"
        Write-Warning "$Link exists and is not a symlink. Backing up to $backup"
        Move-Item -Path $Link -Destination $backup -Force
    }
    New-Item -ItemType SymbolicLink -Path $Link -Target $Target -Force | Out-Null
    Write-Host "    linked: $Link -> $Target"
}

# --------------------------------------------------
# Git config (host-side)
# --------------------------------------------------
Write-Host "==> Git for Windows symlinks"
New-SymlinkIfMissing `
    -Target (Join-Path $RepoRoot 'configs\git\gitconfig') `
    -Link    (Join-Path $env:USERPROFILE '.gitconfig')
New-SymlinkIfMissing `
    -Target (Join-Path $RepoRoot 'configs\git\gitignore_global') `
    -Link    (Join-Path $env:USERPROFILE '.gitignore_global')

# --------------------------------------------------
# PowerShell profile
# --------------------------------------------------
Write-Host "==> PowerShell profile"
$profileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
}
New-SymlinkIfMissing `
    -Target (Join-Path $RepoRoot 'configs\windows\powershell\profile.ps1') `
    -Link    $PROFILE

# --------------------------------------------------
# VS Code (Windows-side)
# --------------------------------------------------
Write-Host "==> VS Code (Windows host)"
$vscodeUser = Join-Path $env:APPDATA 'Code\User'
if (-not (Test-Path $vscodeUser)) { New-Item -ItemType Directory -Force -Path $vscodeUser | Out-Null }
New-SymlinkIfMissing `
    -Target (Join-Path $RepoRoot 'configs\vscode\settings.json') `
    -Link    (Join-Path $vscodeUser 'settings.json')
New-SymlinkIfMissing `
    -Target (Join-Path $RepoRoot 'configs\vscode\keybindings.json') `
    -Link    (Join-Path $vscodeUser 'keybindings.json')

# --------------------------------------------------
# Done
# --------------------------------------------------
Write-Host "==> done."