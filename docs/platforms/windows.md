# Platform: Windows

## Status

This is the **target** platform. The machine will be a Dell workstation
running Windows 11 Pro, supplied by the new employer.

## Architecture

Per `docs/decisions/0001-windows-vs-wsl2.md`, the target is a hybrid:

```text
Dell / Windows 11
│
├── Windows host
│   ├── Corporate management / security tooling
│   ├── Windows Terminal
│   ├── VS Code
│   ├── Browser
│   ├── winget
│   └── Docker Desktop (if licensed/allowed)
│
└── WSL2
    ├── ~/src/                    ← repositories live here
    ├── Git + SSH
    ├── Python + uv
    ├── Go
    ├── Bash
    ├── Terraform / OpenTofu
    ├── kubectl / Helm / k9s
    └── general Linux tooling
```

## Corporate-controlled capabilities

The new employer may restrict any of the following. Plan B per capability:

| Capability | Plan A | Plan B |
| --- | --- | --- |
| WSL2 | enable and use as designed | native Windows dev (see Decision 0001 fallback) |
| Virtualization (Hyper-V) | required for WSL2 + Docker | none — switch to native Windows |
| Docker Desktop | install via winget | Rancher Desktop / Podman Desktop / WSL2-native engine |
| winget | install via App Installer | direct download from upstream |
| Windows Terminal | winget / Microsoft Store | conhost + PowerShell ISE (degraded) |
| Developer Mode | enable for symlinks | store repos on NTFS without symlinks |
| Local admin | required for most installers | per-tool portable installs to `%LOCALAPPDATA%` |

Each row above is an explicit dependency on the new employer's policy. Do
not assume any of them are available. See
`docs/migration/windows-arrival-checklist.md` for the test sequence.

## Configuration

| Concern | Where |
| --- | --- |
| PowerShell profile | `configs/windows/powershell/profile.ps1` |
| Windows-side aliases | `configs/windows/powershell/aliases.ps1` |
| VS Code | `configs/vscode/*` (same files, host or WSL) |
| Git for Windows | `configs/git/gitconfig` (symlinked into both host and WSL) |
| tmux (WSL2) | `configs/tmux/tmux.conf` (symlinked into WSL) |
| Starship (WSL2) | `configs/starship/starship.toml` (symlinked into WSL) |

## Package manager

Per `docs/decisions/0002-windows-package-manager.md`: **winget only**.
Manifest stored at `platforms/windows/packages.txt` (generated, not yet
populated).

## Bootstrap

The full arrival procedure lives in
`docs/migration/windows-arrival-checklist.md`. Summary:

1. Windows Update to current patch level.
2. Install Windows Terminal.
3. `winget install Git.Git`.
4. `wsl --install` (if allowed).
5. Install winget packages from `platforms/windows/packages.txt`.
6. Inside WSL2: clone this repo to `~/src/MY-DEV-ENVIRONMENT`.
7. Symlink dotfiles per `configs/windows/powershell/README.md`.
8. `bash scripts/inventory/validate.sh` to confirm.