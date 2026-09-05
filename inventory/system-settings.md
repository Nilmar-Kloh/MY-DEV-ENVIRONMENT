# System settings — inventory template

Source of truth: `bash scripts/inventory/macos.sh` (`inventory/raw/machine.md`, `shell-files.txt`).

## macOS context

| Item | Captured |
| --- | --- |
| macOS version | from script |
| Hardware model / chip | from script |
| Architecture (arm64 vs x86_64) | from script |
| Default shell | from script |
| Hostname | from script |

## Shell

| File | Source | Notes |
| --- | --- | --- |
| `~/.zshrc` | symlink to this repo | via `bootstrap` step |
| `~/.tmux.conf` | symlink to this repo | via manual `ln -sf` (per `configs/tmux/README.md`) |
| `~/.gitconfig` | symlink to this repo | to set up |
| `~/.gitignore_global` | symlink to this repo | to set up |

See `configs/shell/`, `configs/tmux/`, `configs/git/` for the actual files.

## What is intentionally not migrated

- `.zsh_history`, `.bash_history` — privacy + non-portable
- `Library/Application Support/*` — application state, not configuration
- Per-application caches
- Login items, Keychain entries

## Windows equivalents

| macOS | Windows | Notes |
| --- | --- | --- |
| `/Applications` | `C:\Program Files` + Microsoft Store | winget covers most of this |
| `~/Library/Preferences` | registry + `%APPDATA%` | n/a — application state |
| `~/.zshrc` | PowerShell profile (`$PROFILE`) | See `configs/windows/powershell/` |
| `~/.tmux.conf` | Windows Terminal JSON settings | WSL2 tmux still uses Linux tmux |

## OS-level settings worth preserving

| Setting | Where on Mac | Equivalent on Windows |
| --- | --- | --- |
| Show all filename extensions | Finder → Advanced | File Explorer → View → File name extensions |
| Default editor for source files | `git config --global core.editor` | same (VS Code) |
| Trackpad / keyboard | System Settings | Windows Settings |
| SSH known hosts | `~/.ssh/known_hosts` | managed in WSL2 + Windows host separately |