# Platform: macOS

## Status

This is the **current** platform as of the date of the last
`bash scripts/inventory/macos.sh` run. It will be the outgoing platform
after the company-issued MacBook is returned.

## What is installed (known)

Authoritative source: the `Brewfile` at the repo root, plus
`inventory/raw/cli-tools.txt` after running the inventory script.

Currently managed via Homebrew (per `Brewfile`):

- **CLI**: `bat`, `eza`, `fd`, `ffmpeg`, `fzf`, `gh`, `git-filter-repo`,
  `go`, `jq`, `mkcert`, `node`, `opencode`, `python@3.14`, `ripgrep`,
  `starship`, `tmux`, `uv`
- **Cask**: `iterm2`, `dbeaver-community`

## Configuration

Shell (`configs/shell/`), Git (`configs/git/`), tmux (`configs/tmux/`),
Starship (`configs/starship/`), VS Code (`configs/vscode/`).

The shell setup sources files from this repo via:

```bash
# in ~/.zshrc (symlinked to configs/shell/zshrc)
export DEV_ENV_HOME="$HOME/Code/MY-DEV-ENVIRONMENT"
source "$DEV_ENV_HOME/configs/shell/exports.zsh"
source "$DEV_ENV_HOME/configs/shell/aliases.zsh"
source "$DEV_ENV_HOME/configs/shell/functions.zsh"
```

`exports.zsh` evaluates Homebrew's `brew shellenv` and adds `$HOME/go/bin`
and `$HOME/.opencode/bin` to `PATH`.

## What is NOT migrated (out of scope)

- `.zsh_history`
- `Library/Application Support/*` (app state, not config)
- Per-app caches (`Cache/`, `Caches/`)
- Keychain entries
- Login items
- Time Machine snapshots
- Photos, iCloud Drive, Mail

## Departure checklist

See `docs/migration/pre-return-mac-checklist.md`.