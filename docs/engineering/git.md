# Git

## Purpose

Git is the universal version control tool. This document covers the
configuration that is portable across platforms and the configuration that
is platform-specific.

## What is committed

`configs/git/gitconfig` — the personal `.gitconfig`. Already in the repo.

Currently captures:

- `user.name` (public, fine)
- `user.email` (public, fine)
- `init.defaultBranch = main`
- `pull.rebase = false`
- `push.autoSetupRemote = true`
- `fetch.prune = true`
- `core.editor = code --wait`
- `core.autocrlf = input` (key for cross-platform line-ending safety)
- `core.excludesfile = ~/.gitignore_global`
- `color.ui = auto`
- `rerere.enabled = true`
- `rebase.autosquash = true`
- aliases: `st`, `co`, `br`, `ci`, `lg`

## What is intentionally NOT committed

- Signing keys (GPG / SSH)
- `credential.helper` values that include tokens
- HTTPS remotes with embedded credentials

If signing is desired, the **public** key half may live in the repo under
`configs/git/signing.pub`; the private key never does.

## Global gitignore

`configs/git/gitignore_global` covers:

- macOS / editor artifacts
- Python cache
- VS Code local settings
- Logs
- `.env`, `.env.*`
- Swap files

This file is the same on every platform. Symlink it from WSL2 and from
the Windows host if Git for Windows is used.

## Cross-platform line endings

`core.autocrlf = input` means:

- On commit: convert CRLF → LF.
- On checkout: do not convert back.

This is the correct setting for any developer who primarily edits on
Linux/macOS and occasionally checks out the repo on Windows. Anyone who
primarily develops on Windows should switch to `core.autocrlf = true`
in a per-repo override, or use `.gitattributes` to declare per-file
behavior.

## Symlinking the gitconfig

### macOS / Linux

```bash
ln -sf ~/Code/MY-DEV-ENVIRONMENT/configs/git/gitconfig ~/.gitconfig
ln -sf ~/Code/MY-DEV-ENVIRONMENT/configs/git/gitignore_global ~/.gitignore_global
```

### Windows (PowerShell, admin)

```powershell
New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.gitconfig -Target (Resolve-Path "$env:USERPROFILE\src\MY-DEV-ENVIRONMENT\configs\git\gitconfig")
New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.gitignore_global -Target (Resolve-Path "$env:USERPROFILE\src\MY-DEV-ENVIRONMENT\configs\git\gitignore_global")
```

### WSL2

```bash
ln -sf ~/src/MY-DEV-ENVIRONMENT/configs/git/gitconfig ~/.gitconfig
ln -sf ~/src/MY-DEV-ENVIRONMENT/configs/git/gitignore_global ~/.gitignore_global
```

## Windows Git vs WSL Git

Two Git installations may exist on the new workstation:

- Git for Windows (host)
- Git inside WSL2

Use the one whose filesystem the repo lives on. A repo in `~/src/` (WSL2)
must use WSL2 Git. A repo on `C:\src\` (Windows) must use Git for Windows.
The `gitconfig` is the same in both environments, but credential helpers
and remotes must be set up per environment.

## Validation

```bash
git config --global user.name
git config --global user.email
git config --global init.defaultBranch
git --version
```