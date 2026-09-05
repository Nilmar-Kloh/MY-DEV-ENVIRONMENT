# Git

## Purpose

Git is the universal version control tool. This document covers the
shared (committed) configuration, the platform-specific (uncommitted)
overrides, and the identity boundary that keeps personal and corporate
Git usage from crossing.

## Identity boundary

Git identity (`user.name`, `user.email`) is **never** committed to this
repository. It lives in:

- `~/.gitconfig` (machine-local), or
- `~/.gitconfig.local` (a gitignored symlink managed per-machine)

The shared `configs/git/gitconfig` defines **behavior only**: defaults,
aliases, line-ending policy, gitignore, etc. Identity is added on top of
behavior by whichever file Git loads first.

Reason: this repository is public. Including identity would publish it,
and including an "employer identity" inside a file shared across all
workstations makes it impossible to prevent personal/corporate
crossover. The structure below puts identity in files that are never
committed.

## Include chain

```text
~/.gitconfig                       ← machine-local: identity + per-host tweaks
  │
  └── include → configs/git/gitconfig   (shared portable behavior)
        │
        └── include → ~/.gitconfig.local
              │
              └── symlink target (one of):
                    configs/git/gitconfig.macos
                    configs/git/gitconfig.windows-host
                    configs/git/gitconfig.wsl
```

Order of evaluation matters: Git reads the included content as if it
were inlined at the position of the `[include]` directive. Because the
shared `gitconfig` puts `[include]` after `[init]`/behavioral sections,
local identity (`user.name`/`user.email` in `~/.gitconfig`) takes
precedence over anything the shared file might set — but the shared
file deliberately sets nothing for `[user]`, so there is no
precedence fight.

## What is in the shared config (`configs/git/gitconfig`)

Behavioral only — no identity:

- `init.defaultBranch = main`
- `pull.rebase = false`
- `push.autoSetupRemote = true`
- `fetch.prune = true`
- `core.editor = code --wait`
- `core.autocrlf = input`
- `core.excludesfile = ~/.gitignore_global`
- `color.ui = auto`
- `rerere.enabled = true`
- `rebase.autosquash = true`
- aliases: `st`, `co`, `br`, `ci`, `lg`
- `[include] path = ~/.gitconfig.local`

## What is in each platform override

| File | Scope | Adds |
| --- | --- | --- |
| `configs/git/gitconfig.macos` | macOS host | `credential.helper = osxkeychain`, `gpg.format = ssh`, optional `user.signingkey` |
| `configs/git/gitconfig.windows-host` | Windows host (Git for Windows) | `credential.helper = manager`, `core.symlinks = true`, `gpg.format = ssh` |
| `configs/git/gitconfig.wsl` | WSL2 | `credential.helper` (Windows-side GCM via `/mnt/c/...`) + `store`, explicit `core.autocrlf = input`, `gpg.format = ssh` |

Each platform file is included only when `~/.gitconfig.local` is a
symlink pointing at it. `~/.gitconfig.local` is **gitignored** — it is
a per-machine symlink, never committed content.

## Personal identity

A typical `~/.gitconfig` for personal use:

```ini
[user]
    name = <PERSONAL_NAME>
    email = <PERSONAL_EMAIL>
[include]
    path = ~/Code/MY-DEV-ENVIRONMENT/configs/git/gitconfig
```

The `[user]` block sets identity. The `[include]` brings in shared
behavior. The shared file's own `[include]` then loads the platform
override (when `~/.gitconfig.local` exists).

The Mac currently runs this exact pattern. The user identity and the
repo identity were once both set in the shared file, which caused
committed work on this Mac to be authored under the wrong name. The
shared file no longer carries `[user]`.

## Corporate identity (future)

When a future employer provides Git repositories, separate identity via
`includeIf`. The new employer's identity must NOT be committed to this
public repo.

Add to `~/.gitconfig.local` (or a new `~/.gitconfig.company`,
gitignored):

```ini
[user]
    name = <EMPLOYER_NAME>
    email = <EMPLOYER_EMAIL>

[includeIf "gitdir:~/src/company/"]
    path = ~/.gitconfig.company
```

Conceptually:

```text
~/src/personal/    → personal identity (from ~/.gitconfig)
~/src/homelab/     → personal identity (homelab repos are personal)
~/src/company/     → employer identity (loaded only inside that tree)
```

Do NOT commit corporate identity, corporate paths, or any
`includeIf`-bound corporate file to this repository.

## What is intentionally NOT committed

- Private SSH keys, GPG private keys, signing private keys
- `credential.helper` values that include tokens
- HTTPS remotes with embedded credentials
- The contents of `~/.gitconfig.local` or any `includeIf`-bound file
- Identity of any kind (`user.name`, `user.email`, `user.signingkey`)

If signing is desired, the **public** key path goes in a platform
override (e.g., `user.signingkey = ~/.ssh/id_ed25519.pub`). The private
key never does. Identity may be set in the platform override or in
`~/.gitconfig` — both are local.

## Global gitignore

`configs/git/gitignore_global` covers:

- macOS / editor artifacts
- Python cache
- VS Code local settings
- Logs
- `.env`, `.env.*`
- Swap files

Symlink it the same way on every platform.

## Cross-platform line endings

The shared config sets `core.autocrlf = input`: CRLF → LF on commit, no
conversion on checkout. This is the correct setting for someone who
primarily edits on Linux/macOS and occasionally checks out on Windows.

If a specific repo needs different behavior, set `.gitattributes` or a
local `core.autocrlf` override there — not in the global config.

## Symlinking the gitconfig + platform override

### macOS

```bash
ln -sf ~/Code/MY-DEV-ENVIRONMENT/configs/git/gitconfig ~/.gitconfig
ln -sf ~/Code/MY-DEV-ENVIRONMENT/configs/git/gitignore_global ~/.gitignore_global
ln -sf ~/Code/MY-DEV-ENVIRONMENT/configs/git/gitconfig.macos ~/.gitconfig.local
```

### Windows host (PowerShell)

```powershell
$repo = (Resolve-Path "$env:USERPROFILE\src\MY-DEV-ENVIRONMENT").Path
New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.gitconfig `
    -Target "$repo\configs\git\gitconfig"
New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.gitignore_global `
    -Target "$repo\configs\git\gitignore_global"
New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.gitconfig.local `
    -Target "$repo\configs\git\gitconfig.windows-host"
```

### WSL2

```bash
ln -sf ~/src/MY-DEV-ENVIRONMENT/configs/git/gitconfig ~/.gitconfig
ln -sf ~/src/MY-DEV-ENVIRONMENT/configs/git/gitignore_global ~/.gitignore_global
ln -sf ~/src/MY-DEV-ENVIRONMENT/configs/git/gitconfig.wsl ~/.gitconfig.local
```

## Windows Git vs WSL Git

Two Git installations may exist on the new workstation:

- Git for Windows (host) → uses `gitconfig.windows-host`
- Git inside WSL2 → uses `gitconfig.wsl`

Use the Git whose filesystem the repo lives on:

- Repo in `~/src/` (WSL2) → WSL2 Git + WSL2 platform override.
- Repo on `C:\src\` (Windows) → Git for Windows + Windows-host
  platform override.

Identity is set in `~/.gitconfig` per machine and applies across both
Git installations. Credential helpers, signing, and `core.symlinks`
differ per environment — that is the point of the platform override.

## Verification

The following commands must be run on the live machine after symlinking
the files. They confirm the include chain loads correctly without
recursive expansion.

```bash
git config --show-origin --get user.name
git config --show-origin --get user.email
git config --show-origin --get credential.helper
git config --show-origin --get core.autocrlf
git config --show-origin --get alias.lg
git config --list --show-origin 2>&1 | grep -i 'circular\|recursive\|warning'
```

The last command must produce no output (no recursion warnings).