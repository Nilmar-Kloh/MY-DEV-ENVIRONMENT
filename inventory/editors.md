# Editors — inventory

Source of truth: live editor + `configs/vscode/`.

Tag vocabulary: see `inventory/README.md`.

## VS Code (DETECTED, TARGET)

`configs/vscode/*` is already the portable source of truth. The
committed `extensions.json`, `settings.json`, `keybindings.json` carry
the shared configuration across machines.

| File | Role |
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

### Profile migration

On the new machine:

1. Install VS Code: `winget install Microsoft.VisualStudioCode`.
2. Open VS Code → Command Palette → "Preferences: Open User Settings
   (JSON)".
3. Paste the contents of `configs/vscode/settings.json` **minus the
   macOS-only key** (`terminal.integrated.defaultProfile.osx`). Add a
   Windows-equivalent key (e.g.,
   `terminal.integrated.defaultProfile.windows`).
4. Do NOT copy the user-level `settings.json` from the old Mac; it
   may contain local paths.

### Extensions

Per `configs/vscode/extensions.json`. Capture the installed list with:

```bash
code --list-extensions > inventory/raw/vscode-extensions.txt
```

Install on Windows:

```bash
cat configs/vscode/extensions.json \
  | jq -r '.recommendations[]' \
  | xargs -L1 code --install-extension
```

## Cursor (DETECTED, OPTIONAL)

Detected in `/Applications`. Cursor is a personal fork of VS Code.
Settings sync behavior is product-specific. Do NOT assume shared
settings are mirrored to Cursor automatically.

## Secondary editors

| Editor | Status | Notes |
| --- | --- | --- |
| JetBrains (GoLand / PyCharm / IntelliJ) | [ABSENT] | not currently installed |
| Neovim | [ABSENT] | not currently installed |
| Vim / Vi | [DETECTED] | stock macOS |

## What is NOT migrated

- `~/Library/Application Support/Code/User/settings.json` from the Mac
  (may contain local paths or synced state)
- Workspace trust state, signed-in account state
- Anything under `Code/User/globalStorage/`