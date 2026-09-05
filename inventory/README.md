# Inventory

This directory holds the **versioned inventory** of my development environment.

It is the canonical answer to: *what do I depend on, and how is it currently installed?*

Inventory is captured by running a script on the live machine. Nothing in this
directory should be hand-edited from memory — the source of truth is the script
output, reviewed and committed.

## How it works

| Phase | What | Where |
| --- | --- | --- |
| Capture | Run a read-only inspection script | `scripts/inventory/macos.sh` or `scripts/inventory/windows.ps1` |
| Raw output | Timestamped, machine-specific artifacts | `inventory/raw/` (gitignored) |
| Reviewed inventory | Sanitized, classified Markdown tables | `inventory/*.md` (committed) |

The raw output stays local. The committed inventory is the *reviewed* version.

## Classification

Every item in the committed inventory is tagged:

- **detected** — confirmed by the inspection script on this machine
- **managed** — explicitly installed or configured by the user (Brewfile, dotfile, etc.)
- **company** — provided/managed by corporate IT. Document the name, not the contents.
- **candidate** — worth migrating to the new platform
- **excluded** — intentional: not portable, not personally owned, or not worth migrating

## Files

- `applications.md` — GUI applications in `/Applications` (Mac) or installed programs (Windows)
- `cli-tools.md` — important CLI tools in `PATH`
- `languages.md` — language runtimes and their managers
- `editors.md` — editor/IDE configuration scope (VS Code, Cursor, JetBrains, Neovim)
- `containers.md` — Docker / Colima / Podman / Compose / Buildx
- `infrastructure.md` — kubectl, Helm, Terraform, OpenTofu, Ansible, cloud CLIs
- `system-settings.md` — OS-level configuration worth preserving

## What is intentionally NOT here

- Project-specific virtual environments (`.venv/`)
- Build artifacts, caches, `node_modules/`
- Secrets, tokens, certificates, SSH private keys
- `zsh_history` / shell history
- Anything in `inventory/raw/` (kept local only)

## See also

- `docs/migration/overview.md` — how inventory feeds the migration
- `scripts/inventory/` — the scripts that produce this content