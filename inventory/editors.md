# Editors — inventory template

Source of truth: live editor + `configs/vscode/`.

## Primary editor

**Visual Studio Code** — the committed `configs/vscode/*` files are already
the source of truth for portable settings.

| File | Purpose |
| --- | --- |
| `configs/vscode/settings.json` | User settings (committed, portable) |
| `configs/vscode/extensions.json` | Recommended extensions |
| `configs/vscode/keybindings.json` | Keybindings (currently empty `[]`) |

### Settings highlights

- Font: JetBrains Mono, 14pt
- Format on save (explicit, not auto-imports auto-fix)
- Rulers: 88 and 120
- Tab size: 4
- Go: language server + `gofmt`, no auto-tool updates
- macOS-only: `terminal.integrated.defaultProfile.osx = zsh`

### Settings profile migration

On the new machine:

1. Install VS Code via `winget install Microsoft.VisualStudioCode`
2. Copy `configs/vscode/settings.json` to `~/AppData/Code/User/settings.json` (Windows)
3. Or open the repo in VS Code → Command Palette → "Open User Settings (JSON)"
4. Do NOT copy `Code/User/settings.json` from the company Mac; user-level
   settings may contain machine-specific paths.

### Extensions

Per `configs/vscode/extensions.json`. Capture the installed list with:

```bash
code --list-extensions > inventory/raw/vscode-extensions.txt
```

Then compare against `extensions.json` to find drift.

Install on Windows:

```bash
cat configs/vscode/extensions.json \
  | jq -r '.recommendations[]' \
  | xargs -L1 code --install-extension
```

## Secondary editors (if any)

| Editor | Status |
| --- | --- |
| Cursor | add row when used |
| JetBrains (GoLand / PyCharm / IntelliJ) | add row when used |
| Neovim | add row when used |
| Vim / Vi | already on macOS; on Windows: `winget install Neovim.Neovim` if needed |

## Items NOT to migrate

- `~/Library/Application Support/Code/User/settings.json` from the Mac
  (may contain local paths or synced state)
- Workspace trust state, signed-in account state
- Anything under `Code/User/globalStorage/`