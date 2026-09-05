# Shared configuration (cross-platform)

This directory holds configuration that should apply identically on every
platform. At present, the truly portable items already live in:

- `configs/git/` — Git configuration
- `configs/starship/` — Starship prompt
- `configs/tmux/` — tmux (used inside WSL2 on Windows and natively on macOS/Linux)
- `configs/vscode/` — VS Code settings/extensions/keybindings (mostly portable)

This `shared/` directory is reserved for **new** cross-platform artifacts,
e.g., a portable aliases document that both zsh and PowerShell can source.

Keep this directory minimal. Only add files that genuinely apply on more
than one platform.