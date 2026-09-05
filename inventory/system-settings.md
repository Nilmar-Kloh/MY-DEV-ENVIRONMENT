# System settings — inventory

Source of truth: `bash scripts/inventory/macos.sh` (`inventory/raw/machine.md`, `inventory/raw/shell-files.txt`).

Tag vocabulary: see `inventory/README.md`.

## macOS context (DETECTED)

| Item | Source |
| --- | --- |
| macOS version | `inventory/raw/machine.md` |
| Hardware model / chip | `inventory/raw/machine.md` |
| Architecture (arm64 vs x86_64) | `inventory/raw/machine.md` |
| Default shell | `inventory/raw/machine.md` |
| Hostname | `inventory/raw/machine.md` (raw only) |

Do not transcribe the hostname into the committed inventory.

## Shell (DETECTED)

| File | Status | Notes |
| --- | --- | --- |
| `~/.zshrc` | [DETECTED] | symlink to repo |
| `~/.tmux.conf` | [DETECTED] | symlink to repo (after bootstrap) |
| `~/.gitconfig` | [DETECTED] | not a symlink — see `inventory/raw/shell-files.txt` |
| `~/.gitignore_global` | [DETECTED] | symlink to repo (after bootstrap) |

See `configs/shell/`, `configs/tmux/`, `configs/git/` for the actual
files.

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