# Platform: shared (portable configuration)

Configuration that should travel between operating systems unchanged lives
here. The principle: if a setting means the same thing on macOS, Linux, and
Windows, it should not be triplicated.

## What is portable today

| Item | Portable? | Notes |
| --- | --- | --- |
| Git config (`configs/git/gitconfig`) | yes | by design — `core.autocrlf = input` already handles cross-platform line endings |
| Global gitignore (`configs/git/gitignore_global`) | yes | pure patterns |
| VS Code settings (`configs/vscode/settings.json`) | mostly | one macOS-specific line: `terminal.integrated.defaultProfile.osx`. |
| VS Code extensions (`configs/vscode/extensions.json`) | yes | recommendations |
| VS Code keybindings (`configs/vscode/keybindings.json`) | yes | currently empty |
| Starship prompt (`configs/starship/starship.toml`) | yes | the same file works in PowerShell, Bash, zsh, fish |
| tmux config (`configs/tmux/tmux.conf`) | yes when used in WSL/Linux | n/a on native Windows |
| Aliases (`configs/shell/aliases.zsh`) | zsh only | equivalents in `configs/windows/powershell/aliases.ps1` |
| Functions (`configs/shell/functions.zsh`) | zsh only | PowerShell equivalent in `configs/windows/powershell/` |

## What is NOT portable

- Shell startup (`zshrc`, `bash_profile`, `$PROFILE`) — different syntax
- Homebrew / winget / apt commands — different package managers
- Path syntax (`/opt/homebrew/bin` vs `C:\Program Files\...`)
- macOS-only VS Code keys (`terminal.integrated.defaultProfile.osx`)
- Anything that depends on a specific OS filesystem feature

## Reusable concepts

Even where syntax differs, the *concepts* are reusable:

| Concept | zsh location | PowerShell location |
| --- | --- | --- |
| Navigation aliases | `configs/shell/aliases.zsh` | `configs/windows/powershell/aliases.ps1` |
| Modern `ls` / `cat` aliases (`eza` / `bat`) | same | same intent |
| Git short aliases | same | same intent |
| `mkcd` function | `configs/shell/functions.zsh` | PowerShell function in `profile.ps1` |
| Editor env vars | `configs/shell/exports.zsh` | PowerShell `$env:EDITOR = ...` |

## Promoting a setting to "shared"

When a new setting is identical across platforms, move it into
`configs/shared/` and reference it from both `configs/shell/` and
`configs/windows/powershell/`. The current `configs/shared/` directory is
intentionally minimal — populate only when there is real reuse.