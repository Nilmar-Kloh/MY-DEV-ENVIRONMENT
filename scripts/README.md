# Scripts

This directory is organized by automation tier. Each subdirectory has a
README explaining what the scripts in it do.

## Inventory

| Script | Purpose | Platform |
| --- | --- | --- |
| `inventory/macos.sh` | Read-only inspection of the current Mac | macOS |
| `inventory/windows.ps1` | Read-only inspection of a Windows workstation (host + WSL) | Windows |
| `inventory/validate.sh` | Verify required tools exist | any POSIX shell |

## Bootstrap

| Script | Purpose | Platform |
| --- | --- | --- |
| `bootstrap/macos.sh` | Install Brewfile + symlink dotfiles | macOS |
| `bootstrap/windows.ps1` | Import winget manifest + symlink dotfiles | Windows host |

## Conventions

- Read-only scripts (`inventory/*`) MUST NOT modify the system.
- Mutating scripts (`bootstrap/*`) MUST be idempotent.
- No script should print secret values.
- No script should commit to git. The user reviews output, then commits.