# MY-DEV-ENVIRONMENT

A version-controlled source of truth for my development workstation
configuration, oriented around one operational goal:

**Rebuild my legitimate personal development environment on a different
machine, with confidence, without retaining anyone else's material.**

The repository currently models a transition from a company-issued
**macOS** workstation to a **Dell Windows 11** workstation.

## Philosophy

See [`docs/philosophy.md`](docs/philosophy.md). In short:

- Git is the source of truth for configuration, not secrets.
- Reconstruct environments; do not copy machines.
- Prefer declarative manifests over memory.
- Keep OS-specific configuration isolated.
- Minimize package-manager sprawl.
- Avoid unnecessary frameworks.

## Supported platforms

| Platform | Role | Doc |
| --- | --- | --- |
| macOS | current (outgoing) | [`docs/platforms/macos.md`](docs/platforms/macos.md) |
| Windows 11 + WSL2 | target (incoming) | [`docs/platforms/windows.md`](docs/platforms/windows.md) |
| Cross-platform | shared concepts | [`docs/platforms/shared.md`](docs/platforms/shared.md) |

## Repository layout

```text
MY-DEV-ENVIRONMENT
├── README.md                              this file
├── Brewfile                               macOS package manifest
├── .editorconfig
├── .gitignore                             hardened (SSH keys, kubeconfig, cloud creds, …)
│
├── configs/                               portable + platform-specific dotfiles
│   ├── git/                               gitconfig, global gitignore
│   ├── shell/                             zsh config (current Mac + future WSL)
│   ├── starship/                          Starship prompt
│   ├── tmux/                              tmux config
│   ├── vscode/                            VS Code settings/extensions/keybindings
│   ├── windows/powershell/                Windows host PowerShell profile
│   └── shared/                            reserved for cross-platform reuse
│
├── docs/
│   ├── philosophy.md                      engineering principles
│   ├── secrets-policy.md                  what NEVER gets committed
│   ├── security-audit.md                  audit findings
│   ├── engineering/                       per-tool documentation
│   │   ├── shell.md
│   │   ├── go.md
│   │   ├── python.md
│   │   ├── docker.md
│   │   ├── git.md
│   │   └── database.md
│   ├── platforms/                         per-platform documentation
│   ├── decisions/                         architecture decision records (ADRs)
│   └── migration/                         operational migration plan
│
├── inventory/                             reviewed, sanitized inventory of the machine
│   ├── applications.md
│   ├── cli-tools.md
│   ├── languages.md
│   ├── editors.md
│   ├── containers.md
│   ├── infrastructure.md
│   └── system-settings.md
│
├── platforms/                             platform-specific configuration files
│   ├── macos/
│   ├── windows/                           (will host packages.txt when generated)
│   └── shared/
│
├── manifests/                             package-manager manifests
│   ├── macos/                             → root Brewfile
│   ├── windows/                           → platforms/windows/packages.txt
│   └── shared/
│
├── scripts/
│   ├── inventory/                         read-only inspection scripts
│   │   ├── macos.sh
│   │   ├── windows.ps1
│   │   └── validate.sh                    cross-platform tool checker
│   └── bootstrap/                         idempotent installers
│       ├── macos.sh
│       └── windows.ps1
│
└── templates/                             copy-and-edit skeletons
    └── .env.example
```

## Quick start

### Inventory the current Mac (before returning it)

```bash
bash scripts/inventory/macos.sh
# inspect inventory/raw/, then update inventory/*.md
```

### Bootstrap a fresh macOS machine

```bash
bash scripts/bootstrap/macos.sh
```

### Bootstrap the new Dell Windows workstation

```powershell
# from the cloned repo on the Windows host
pwsh scripts/bootstrap/windows.ps1
```

WSL2-side setup is documented in
[`docs/migration/windows-arrival-checklist.md`](docs/migration/windows-arrival-checklist.md).

### Validate the toolchain

```bash
bash scripts/inventory/validate.sh          # POSIX (macOS, Linux, WSL)
```

## Migration documentation

- [`docs/migration/overview.md`](docs/migration/overview.md) — workflow
- [`docs/migration/pre-return-mac-checklist.md`](docs/migration/pre-return-mac-checklist.md) — before handing back the MacBook
- [`docs/migration/windows-arrival-checklist.md`](docs/migration/windows-arrival-checklist.md) — first-day procedure on the Dell
- [`docs/migration/mac-to-windows-matrix.md`](docs/migration/mac-to-windows-matrix.md) — per-tool mapping

## Architectural decisions

- [ADR 0001 — Windows + WSL2 hybrid](docs/decisions/0001-windows-vs-wsl2.md)
- [ADR 0002 — winget as primary Windows package manager](docs/decisions/0002-windows-package-manager.md)

## What is intentionally NOT in this repository

- Private SSH keys, GPG private keys, signing keys
- Cloud credentials (`~/.aws/`, `~/.config/gcloud/`, kubeconfig)
- Tokens, passwords, `.env` files with values
- Company-owned material: VPN configs, MDM payloads, internal hosts,
  corporate certificates
- Shell history (`.zsh_history`, `.bash_history`)
- Per-project virtual environments, caches, build artifacts

See [`docs/secrets-policy.md`](docs/secrets-policy.md).

## Obsidian (personal notes, not part of the dev environment)

I use Obsidian with one folder for notes and another for Kanban boards
housed by area. Plugins and theme list is intentionally not tracked in
this repo because Obsidian's vault is personal and is not part of the
machine's development configuration.

## AI assistance

Some of the configurations, inventory scripts, and migration
documentation in this repository were drafted with AI assistance. Every
file has been reviewed and adjusted for the actual workstation it
serves.