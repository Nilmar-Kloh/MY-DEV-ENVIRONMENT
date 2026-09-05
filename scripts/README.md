# Scripts

This directory is organized by automation tier. Each subdirectory has a
README explaining what the scripts in it do.

## Inventory

| Script | Purpose | Platform |
| --- | --- | --- |
| `inventory/macos.sh` | Read-only inspection of the current Mac | macOS |
| `inventory/windows.ps1` | Read-only inspection of a Windows workstation (host + WSL) | Windows |
| `inventory/validate.sh` | Verify required tools exist; profile-aware | macOS, Linux, WSL |
| `inventory/validate.ps1` | Same as above, PowerShell variant | Windows host |

## Bootstrap

| Script | Purpose | Platform |
| --- | --- | --- |
| `bootstrap/macos.sh` | Install Brewfile + symlink dotfiles; `--dry-run`, `--force`, `--skip-brew` | macOS |
| `bootstrap/windows.ps1` | Import winget manifest + symlink dotfiles; `-DryRun`, `-Force`, `-SkipWinget` | Windows host |

## Conventions

- Read-only scripts (`inventory/macos.sh`, `inventory/windows.ps1`)
  MUST NOT modify the system.
- Mutating scripts (`bootstrap/*`) MUST be idempotent and MUST respect
  a `--dry-run` / `-DryRun` mode that previews actions without making
  any changes.
- `--force` / `-Force` is opt-in. Existing real (non-symlink) files are
  always skipped by default.
- No script should print secret values.
- No script should commit to git. The user reviews output, then commits.