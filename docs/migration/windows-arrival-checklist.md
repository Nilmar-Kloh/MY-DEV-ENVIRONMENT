# Windows arrival checklist

Use this checklist on the new Dell Windows workstation. Run the steps in
order; do not skip ahead, because later steps depend on earlier ones
(network connectivity, symlinks, etc.).

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
- [ ] 🧑‍💻 Set execution policy for the current user:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

- [ ] 🧑‍💻 Install PowerShell 7 from Microsoft Store or `winget install
      Microsoft.PowerShell` if not present.

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

---

## Phase 3 — WSL2 (you + corporate IT)

Per `docs/decisions/0001-windows-vs-wsl2.md`, WSL2 is the primary
development environment for Linux-oriented tools.

### 3.1 Enable WSL2

```powershell
wsl --install
```

This installs the WSL2 kernel and Ubuntu by default.

- [ ] 🏢 If `wsl --install` fails with an admin or virtualization error,
      open an IT ticket requesting WSL2 enablement.
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

### 3.6 Install Linux tooling

Per `platforms/macos/Brewfile` analogues, install inside WSL:

- [ ] 🧑‍💻 **Python + uv**: install `uv` per the official instructions:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

uv manages its own Python; no apt Python needed unless a project
specifically requires it.

- [ ] 🧑‍💻 **Go**: install from `go.dev` (or use `brew` if Linuxbrew is
      installed):

```bash
# example for the current stable Linux Go release
wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
```

Pin the version to match what the macOS side uses; capture the macOS
version with `bash scripts/inventory/macos.sh` and update the URL here.

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

- [ ] 🧑‍💻 Edit `configs/shell/exports.zsh` for WSL: see
      `configs/shared/README.md` — the `/opt/homebrew/bin/brew shellenv`
      line must be guarded or removed when running in WSL.

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

- [ ] 🧑‍💻 Copy `configs/vscode/settings.json` into
      `%APPDATA%\Code\User\settings.json`, OR open Command Palette and
      "Preferences: Open User Settings (JSON)" and paste the contents.
- [ ] 🧑‍💻 Install recommended extensions:

```powershell
# from a Git Bash or WSL shell in the repo root
code --install-extension $(jq -r '.recommendations[]' configs/vscode/extensions.json | tr '\n' ' ')
```

- [ ] 🧑‍💻 Remove the macOS-only setting if it carries over:

```jsonc
// remove this line from settings.json once on Windows:
"terminal.integrated.defaultProfile.osx": "zsh"
```

Replace with:

```jsonc
"terminal.integrated.defaultProfile.windows": "Ubuntu (WSL)"
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

- [ ] 🔑 Generate a new SSH key on the new machine (do not transfer the
      old one unless you generated it on personal hardware):

```bash
ssh-keygen -t ed25519 -C "your-personal-email@example.com"
```

- [ ] 🔑 Add to `ssh-agent` and to GitHub / GitLab as appropriate.
- [ ] 🧑‍💻 From the Mac (before returning), if you want to keep a copy
      of the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Add it manually to GitHub. The private key stays on the personal backup
or is regenerated on the new machine.

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

In a WSL shell:

```bash
cd ~/src/MY-DEV-ENVIRONMENT
bash scripts/inventory/validate.sh
```

Expected:

```text
OK      git         ...
OK      python3     ...
OK      uv          ...
OK      go          ...
OK      docker      ...
... (other tools)
```

If `MISSING` appears, install the tool and rerun.

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