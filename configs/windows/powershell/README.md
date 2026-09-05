# Windows PowerShell configuration

This directory holds PowerShell profile pieces used on the **Windows host**.
WSL2 has its own shell (zsh) configuration under `configs/shell/`.

## Files

| File | Role |
| --- | --- |
| `profile.ps1` | the host PowerShell profile (sources the others) |
| `aliases.ps1` | host-side aliases (equivalent to `configs/shell/aliases.zsh`) |

## Where they go on disk

PowerShell reads its profile from `$PROFILE`. The default value on Windows
is:

```text
$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

Two practical options to install:

### Option A — symlinks (recommended if Developer Mode is on)

```powershell
# Run from an elevated PowerShell in this repo's root.
$repo = (Resolve-Path "$env:USERPROFILE\src\MY-DEV-ENVIRONMENT").Path

# Ensure the profile directory exists
New-Item -ItemType Directory -Force -Path (Split-Path $PROFILE) | Out-Null

# Symlink the profile
New-Item -ItemType SymbolicLink -Path $PROFILE -Target "$repo\configs\windows\powershell\profile.ps1" -Force
```

### Option B — copy (fallback if Developer Mode is off)

```powershell
Copy-Item "$repo\configs\windows\powershell\profile.ps1" $PROFILE -Force
```

You will need to re-copy when the file changes if you take this option.

## Loading

After installation, open a new PowerShell window. Confirm:

```powershell
Get-Item $PROFILE
# Should resolve to either:
#   the symlink, or
#   the copied file
```

## What is NOT here

- Git for Windows configuration (see `configs/git/`).
- WSL2-side shell (see `configs/shell/`).
- Anything that depends on a path that won't exist on the Windows host.