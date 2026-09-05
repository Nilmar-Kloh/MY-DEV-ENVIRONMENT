# Windows arrival checklist

Use this checklist on the new Dell Windows workstation. Run the steps in
order; do not skip ahead, because later steps depend on earlier ones
(network connectivity, symlinks, etc.).

## Detect, don't assume

A new-employer Windows workstation is governed by policies you do not
control. Several capabilities that look obvious may be restricted:

- local administrator privileges
- Developer Mode (required for non-admin symlink creation)
- PowerShell execution policy (`Set-ExecutionPolicy` may be locked)
- WSL2 / Hyper-V / virtualization
- Docker Desktop (license + corporate approval)
- winget / App Installer availability
- Package installation to `C:\Program Files`

**Each step below either detects the capability or has a documented
fallback.** When a step fails, do not try to bypass the restriction;
open an IT ticket and switch to the fallback while waiting. Phase 7
tracks the corporate IT items as a separate list.

## Legend

| Symbol | Meaning |
| --- | --- |
| 🧑‍💻 | You can do this yourself |
| 🏢 | Likely requires corporate IT |
| 🔑 | Requires credentials or approvals |
| ⚠️ | Verify before running |
| ⏸️ | Stop and read |

---

## Phase 1 — Foundation (you)

### 1.1 First boot

- [ ] 🏢 Power on. Sign in with corporate credentials if required.
- [ ] 🧑‍💻 Confirm Windows version: `Settings → System → About`. Expect
      Windows 11 Pro or Enterprise.
- [ ] ⏸️ If the machine is enrolled in MDM (Intune / similar), do NOT
      try to bypass it. Continue with the next steps; many corporate
      policies co-exist with developer tools.

### 1.2 Windows Update

- [ ] 🧑‍💻 `Settings → Windows Update → Check for updates`.
- [ ] 🧑‍💻 Install all critical and security updates.
- [ ] 🧑‍💻 Reboot and repeat until "You're up to date."

### 1.3 Administrator status

- [ ] 🏢 Confirm you have local administrator privileges. If not, the
      bootstrap will fail at any `winget install` step that requires
      elevation. Open a ticket with IT.

```powershell
whoami /groups | findstr /i "admin"
```

### 1.4 PowerShell

- [ ] 🧑‍💻 Open PowerShell as Administrator.
- [ ] 🧑‍💻 Confirm version ≥ 7 if available: `$PSVersionTable.PSVersion`.
- [ ] 🧑‍💻 Install PowerShell 7 from Microsoft Store or `winget install
      Microsoft.PowerShell` if not present.

#### 1.4.1 Execution policy

- [ ] 🧑‍💻 Detect the current execution policy:

```powershell
Get-ExecutionPolicy -List
```

- [ ] ⚠️ If `CurrentUser` is `Undefined` or `RemoteSigned`, the
      scripts in this repo will run. No action needed.
- [ ] ⚠️ If `CurrentUser` is `Restricted` or `AllSigned`, and the
      `LocalMachine` scope is also restrictive, profile scripts will
      be blocked. Two options:
  - Change the user scope (may itself be locked):

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

  - If the change is denied by policy, fall back to running scripts
    with `pwsh -ExecutionPolicy Bypass -File <path>` or invoke the
    `bootstrap`/`inventory` scripts with `bash` via WSL2.

---

## Phase 2 — Core shell and Git (you)

### 2.1 Windows Terminal

- [ ] 🧑‍💻 `winget install Microsoft.WindowsTerminal`.
- [ ] 🧑‍💻 Set as default terminal: `Settings → Developers → Terminal → Windows Terminal`.

### 2.2 Git for Windows

- [ ] 🧑‍💻 `winget install Git.Git`.
- [ ] 🧑‍💻 Accept defaults except: set default branch to `main`, choose
      VS Code as the default editor, enable symlinks (see `core.symlinks`).
- [ ] 🧑‍💻 Confirm:

```powershell
git --version
```

### 2.3 Symlink support on Windows

- [ ] ⚠️ Developer Mode is required for non-admin users to create
      symlinks.
- [ ] 🧑‍💻 If you have admin: enable Developer Mode
      (`Settings → Privacy & security → For developers`).
- [ ] 🏢 If you do not have admin: open an IT request. Alternatively,
      see `platforms/windows/README.md` for the "copy instead of symlink"
      fallback.

### 2.4 Git platform-specific override (host side)

If you will also use Git for Windows on the host (not just inside
WSL2), point it at the Windows-host platform override:

```powershell
$repo = (Resolve-Path "$env:USERPROFILE\src\MY-DEV-ENVIRONMENT").Path
New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.gitconfig.local `
    -Target "$repo\configs\git\gitconfig.windows-host"
```

This sets `credential.helper = manager` and `core.symlinks = true`.
Inside WSL2, use `configs/git/gitconfig.wsl` instead. See
`docs/engineering/git.md` for the full design.

---

## Phase 3 — WSL2 (you + corporate IT)

Per `docs/decisions/0001-windows-vs-wsl2.md`, WSL2 is the primary
development environment for Linux-oriented tools.

### 3.1 Detect / enable WSL2

Per `docs/decisions/0001-windows-vs-wsl2.md`, WSL2 is the preferred
environment for Linux-oriented tools. It is **not** mandatory — see
Decision 0001 for the fallback to native Windows.

- [ ] 🧑‍💻 Detect existing WSL state:

```powershell
wsl --status
wsl -l -v
```

- [ ] ⚠️ If a distro is already installed, skip the install step below.
- [ ] 🧑‍💻 To install (requires admin + Hyper-V + virtualization):

```powershell
wsl --install
```

This installs the WSL2 kernel and Ubuntu by default.

- [ ] 🏢 If `wsl --install` fails with admin, virtualization, or
      licensing errors, open an IT ticket. While waiting, follow the
      native-Windows fallback in `docs/decisions/0001-windows-vs-wsl2.md`.
- [ ] 🧑‍💻 Reboot.
- [ ] 🧑‍💻 Set WSL2 as the default version:

```powershell
wsl --set-default-version 2
```

### 3.2 Pick and provision a distro

- [ ] 🧑‍💻 Install Ubuntu (or Fedora if you prefer; see
      `docs/platforms/windows.md`):

```powershell
wsl --install -d Ubuntu
```

- [ ] 🧑‍💻 First launch: create your UNIX user (use the same username as
      your Windows user for ergonomics).
- [ ] 🧑‍💻 Update:

```bash
sudo apt update && sudo apt upgrade -y
```

### 3.3 Install Linux-side essentials

Inside the WSL distro:

```bash
sudo apt install -y build-essential curl wget git unzip ca-certificates
```

### 3.4 Clone MY-DEV-ENVIRONMENT into WSL

Repositories live inside the WSL filesystem, NOT in `/mnt/c`.

```bash
mkdir -p ~/src
cd ~/src
git clone git@github.com:Nilmar-Kloh/MY-DEV-ENVIRONMENT.git
cd MY-DEV-ENVIRONMENT
```

### 3.5 Symlink dotfiles into WSL

```bash
mkdir -p ~/.config
ln -sf ~/src/MY-DEV-ENVIRONMENT/configs/git/gitconfig ~/.gitconfig
ln -sf ~/src/MY-DEV-ENVIRONMENT/configs/git/gitignore_global ~/.gitignore_global
ln -sf ~/src/MY-DEV-ENVIRONMENT/configs/tmux/tmux.conf ~/.tmux.conf
ln -sf ~/src/MY-DEV-ENVIRONMENT/configs/starship/starship.toml ~/.config/starship.toml
```

Also set up the platform-specific Git override:

```bash
ln -sf ~/src/MY-DEV-ENVIRONMENT/configs/git/gitconfig.wsl ~/.gitconfig.local
```

See `docs/engineering/git.md` for the two-layer Git design.

### 3.6 Install Linux tooling

Per `platforms/macos/Brewfile` analogues, install inside WSL:

- [ ] 🧑‍💻 **Python + uv**: install `uv` per the official instructions:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

uv manages its own Python; no apt Python needed unless a project
specifically requires it.

- [ ] 🧑‍💻 **Go**: install from `go.dev` (Linux tarball; no Homebrew
      required). Visit `https://go.dev/dl/` and download the current
      stable Linux tarball for your architecture (typically
      `linux-amd64` for x86_64 systems, `linux-arm64` for ARM):

```bash
# example (replace <version> and <arch> with the current stable release)
wget https://go.dev/dl/go<version>.linux-<arch>.tar.gz
sudo tar -C /usr/local -xzf go<version>.linux-<arch>.tar.gz
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
```

Verify the installed version matches the macOS side:

```bash
go version
```

If exact version parity matters, capture the macOS version with
`bash scripts/inventory/macos.sh` (see `inventory/raw/languages.txt`)
and download the same version.

- [ ] 🧑‍💻 **kubectl**: `https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/`
- [ ] 🧑‍💻 **Helm**: `https://helm.sh/docs/intro/install/`
- [ ] 🧑‍💻 **Terraform / OpenTofu**: download from upstream.
- [ ] 🧑‍💻 **k9s**: `https://k9scli.io/topics/install/`
- [ ] 🧑‍💻 **ffmpeg, jq, bat, eza, fd, ripgrep, fzf, tmux, starship**:
      install via the distro package manager or download from upstream.

### 3.7 Configure the shell

- [ ] 🧑‍💻 Inside WSL, set zsh as the login shell:

```bash
chsh -s $(which zsh)
```

- [ ] 🧑‍💻 Make `~/.zshrc` source from the repo. Either symlink:

```bash
ln -sf ~/src/MY-DEV-ENVIRONMENT/configs/shell/zshrc ~/.zshrc
```

…or copy `configs/shell/zshrc` and adjust `$DEV_ENV_HOME` to point to
`~/src/MY-DEV-ENVIRONMENT`.

`configs/shell/exports.zsh` already guards the Homebrew block — it
activates only when `/opt/homebrew/bin/brew` or `/usr/local/bin/brew`
exists, so WSL2 with no Homebrew installed needs no edits.

---

## Phase 4 — Windows-side GUI tooling (you)

### 4.1 Visual Studio Code

- [ ] 🧑‍💻 `winget install Microsoft.VisualStudioCode`.

### 4.2 VS Code Remote - WSL extension

- [ ] 🧑‍💻 Install the extension:

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

- [ ] 🧑‍💻 Open a WSL terminal:

```bash
cd ~/src/MY-DEV-ENVIRONMENT
code .
```

This opens the repo in VS Code on the Windows host, with all editing,
terminals, and extensions running inside WSL2.

### 4.3 Apply committed VS Code configuration

The committed `configs/vscode/settings.json` contains one macOS-only
key (`terminal.integrated.defaultProfile.osx`). On Windows, replace
that line with the Windows-side equivalent rather than carrying it
forward verbatim:

```jsonc
// In the user settings.json on the Windows host:
// remove this line:
"terminal.integrated.defaultProfile.osx": "zsh"
// replace with:
"terminal.integrated.defaultProfile.windows": "Ubuntu (WSL)"
```

Steps:

- [ ] 🧑‍💻 Open Command Palette → "Preferences: Open User Settings (JSON)".
- [ ] 🧑‍💻 Paste the contents of `configs/vscode/settings.json` minus
      the macOS-only key. Add the Windows replacement key above.
- [ ] 🧑‍💻 Install recommended extensions:

```powershell
# from a Git Bash or WSL shell in the repo root
code --install-extension $(jq -r '.recommendations[]' configs/vscode/extensions.json | tr '\n' ' ')
```

### 4.4 Docker Desktop

- [ ] 🏢 Confirm with the new employer's IT whether Docker Desktop is
      permitted. Some companies ban it for licensing or security
      reasons.
- [ ] 🧑‍💻 If approved:

```powershell
winget install Docker.DockerDesktop
```

- [ ] 🧑‍💻 Enable WSL2 backend in Docker Desktop → Settings →
      Resources → WSL Integration.
- [ ] 🧑‍💻 Validate inside WSL:

```bash
docker run --rm hello-world
```

- [ ] 🧑‍💻 If Docker Desktop is not approved, fall back to Rancher
      Desktop (`winget install SUSE.RancherDesktop`) or Podman Desktop.
      See `docs/engineering/docker.md`.

### 4.5 Other Windows GUI tooling

- [ ] 🧑‍💻 `winget install DBeaver.DBeaverCommunity` (if not provided by
      corporate IT).
- [ ] 🧑‍💻 `winget install Obsidian.Obsidian`.
- [ ] 🧑‍💻 Browser: follow corporate policy. Personal Chrome/Firefox
      profiles may already be available via sign-in.

---

## Phase 5 — Authentication (you + credentials)

### 5.1 SSH keys

SSH follows the identity-based policy in `docs/engineering/ssh.md`.
There is no universal "generate a new key" rule — the correct action
depends on whose identity the key represents.

- [ ] 🔑 **Personal** (GitHub / GitLab / personal servers): restore
      from a secure personal backup **or** generate a fresh key on the
      new machine:

```bash
ssh-keygen -t ed25519 -C "<PERSONAL_EMAIL>"
ssh-add ~/.ssh/id_ed25519
```

- [ ] 🔑 Register the public half with each personal service, then
      verify (`ssh -T git@github.com` or equivalent).
- [ ] 🚫 **Outgoing-company**: migrate nothing. Leave all
      employer-provisioned keys, certificates, and host stanzas on the
      old machine.
- [ ] 🏢 **New-company**: provision exactly as the new employer's
      security policy dictates (algorithm, certificates vs keys, SSO,
      hardware tokens). Ask IT; do not assume.
- [ ] 🧑‍💻 **Homelab**: restore personal keys from a secure personal
      backup using a safe channel (never this public repo). Keep
      internal addresses out of committed files; see
      `docs/engineering/ssh.md` for the sanitized-pattern format.

### 5.2 Cloud authentication

- [ ] 🔑 `aws sso login` (or whichever mechanism your new employer uses).
- [ ] 🔑 `gcloud auth login`.
- [ ] 🔑 `az login`.
- [ ] 🔑 Cluster credentials: do NOT commit. Use `kubectl config
      use-context` against a freshly downloaded kubeconfig.

### 5.3 GitHub / GitLab authentication

- [ ] 🔑 Personal: re-authenticate on the new machine.
- [ ] 🏢 Corporate: request access via IT.

---

## Phase 6 — Validation

### 6.1 Run the validator

The validator takes a `--profile` flag that matches the environment
you're checking. Pick the one you are currently inside:

```bash
cd ~/src/MY-DEV-ENVIRONMENT

# Inside WSL2
bash scripts/inventory/validate.sh --profile wsl

# Inside Windows Terminal (PowerShell)
pwsh -Command "./scripts/inventory/validate.ps1 --profile windows-host"

# On a Mac (current)
bash scripts/inventory/validate.sh --profile mac
```

A profile is a curated set of tools that should be present. `MISSING`
indicates the tool is required by the profile but absent on this
machine. `missing (optional)` indicates optional tooling that has not
been installed yet.

### 6.2 End-to-end smoke test

- [ ] 🧑‍💻 In WSL: `git clone <personal-repo> ~/src/<repo> && cd
      ~/src/<repo>` and `code .`.
- [ ] 🧑‍💻 VS Code Remote indicator should show "WSL: Ubuntu".
- [ ] 🧑‍💻 Run the project's install + test commands; confirm parity
      with macOS behavior.

### 6.3 Capture the new inventory

- [ ] 🧑‍💻 `pwsh scripts/inventory/windows.ps1` from inside the repo.
- [ ] 🧑‍💻 Commit sanitized output to `inventory/windows.md` (create if
      it doesn't exist).

---

## Phase 7 — Corporate IT dependencies (async)

For each item below, open a ticket or note the status:

| Item | Status |
| --- | --- |
| Local administrator privileges | ☐ granted / ☐ denied |
| WSL2 enablement | ☐ working / ☐ blocked |
| Hyper-V / virtualization | ☐ working / ☐ blocked |
| Docker Desktop license | ☐ approved / ☐ denied / ☐ N/A |
| VPN client | ☐ installed / ☐ pending |
| Internal PKI | ☐ installed / ☐ pending |
| Code-signing certificate | ☐ installed / ☐ pending |
| Internal package mirror | ☐ configured / ☐ pending |

When an item is "denied" or "blocked", fall back per
`docs/platforms/windows.md`.