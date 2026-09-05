# Mac → Windows migration matrix

Per-tool mapping. Source of truth for what to install and where to put it
on the new machine.

Symbols:

- 🪟 = Windows host
- 🐧 = WSL2 distro
- ✅ = exact equivalent
- ⚖️ = same concept, different implementation
- 🟡 = close but not identical
- 🛠️ = manual effort required
- 🚫 = not migrated

## Shell, terminal, prompt

| macOS | Role | Windows equivalent | Where | Status |
| --- | --- | --- | --- | --- |
| zsh | default shell | zsh in WSL2 (or PowerShell 7 native) | 🐧 | ⚖️ |
| Starship prompt | prompt | Starship prompt (same binary) | 🐧 | ✅ |
| iTerm2 | terminal emulator | Windows Terminal | 🪟 | ⚖️ |
| tmux | multiplexer | tmux in WSL2 | 🐧 | ✅ |
| eza | modern ls | `eza` in WSL2 (distro package or upstream release at eza.rocks) | 🐧 | 🟡 |
| bat | modern cat | `bat` | 🐧 | 🟡 |
| fd | modern find | `fd` | 🐧 | 🟡 |
| ripgrep | modern grep | `rg` | 🐧 | 🟡 |
| fzf | fuzzy finder | `fzf` | 🐧 | ✅ |
| jq | JSON CLI | `jq` | 🐧 | ✅ |

`configs/shell/*` carries over to WSL2 zsh. `$DEV_ENV_HOME` must point
at the WSL2 checkout (`~/src/MY-DEV-ENVIRONMENT`); the Homebrew block in
`configs/shell/exports.zsh` is already guarded and is a no-op without
Homebrew installed.

`configs/tmux/tmux.conf` → same file, symlinked into WSL.

`configs/starship/starship.toml` → same file, symlinked into WSL.

## Editors

| macOS | Role | Windows equivalent | Where | Status |
| --- | --- | --- | --- | --- |
| VS Code | primary editor | VS Code | 🪟 | ✅ |
| VS Code extensions | extensions | same IDs | 🪟 | ✅ |
| VS Code settings | user settings | `settings.json` (remove macOS-only keys) | 🪟 | ⚖️ |
| VS Code keybindings | keybindings | same file | 🪟 | ✅ |

## Languages

Python, Go, and Node/npm are detected on the Mac. Ruff, mypy/pyright,
pipx, and pnpm are **absent** there (`[ABSENT][TARGET]`) — wanted on
the Dell, not part of the outgoing environment.

| macOS | Role | Windows equivalent | Where | Status |
| --- | --- | --- | --- | --- |
| `python@<version>` (brew) | Python | `uv` (manages its own Python) | 🐧 | ⚖️ |
| `uv` | Python toolchain | `uv` | 🐧 | ✅ |
| `node` (brew) | Node runtime | winget `OpenJS.NodeJS.LTS` or nvm | 🐧 | 🟡 |
| `go` (brew) | Go | go.dev tarball | 🐧 | ✅ |
| uv tool / pipx | global Python CLIs | `uv tool` | 🐧 | ✅ |
| Ruff | linter / formatter | `ruff` | 🐧 | ✅ |
| mypy / pyright | type check | same | 🐧 | ✅ |
| pytest | tests | same | 🐧 | ✅ |
| uvicorn | ASGI server | same | 🐧 | ✅ |

Project `.venv/` directories are NOT migrated. Regenerate with `uv sync`
per project.

## Containers

| macOS | Role | Windows equivalent | Where | Status |
| --- | --- | --- | --- | --- |
| Docker Desktop | runtime | Docker Desktop | 🪟 | ⚖️ |
| Compose | orchestration | Compose | 🐧 | ✅ |
| Buildx | extended build | Buildx | 🐧 | ✅ |

See `docs/engineering/docker.md` for fallbacks.

## Infrastructure

The live Mac inventory reports kubectl, helm, k9s, terraform, and tofu
as **absent**. They are `[ABSENT][TARGET]` — wanted on the Dell, not
part of the outgoing Mac environment.

| macOS | Role | Windows equivalent | Where | Status |
| --- | --- | --- | --- | --- |
| kubectl | k8s CLI | upstream binary or distro package | 🐧 | ✅ |
| helm | k8s pkg mgr | upstream script | 🐧 | ✅ |
| k9s | k8s TUI | upstream release | 🐧 | ✅ |
| terraform | IaC | upstream zip | 🐧 | ✅ |
| tofu | IaC fork | upstream installer | 🐧 | ✅ |
| ansible | config mgmt | distro package manager (`apt install ansible`) | 🐧 | ✅ |

`~/.kube/config`, `~/.aws/credentials`, etc. are NEVER migrated. See
`docs/secrets-policy.md`.

## Cloud CLIs

| macOS | Role | Windows equivalent | Where | Status |
| --- | --- | --- | --- | --- |
| aws | AWS CLI | `winget install Amazon.AWSCLI` or use SSO | 🪟 | ✅ |
| gcloud | GCP CLI | `winget install Google.CloudSDK` | 🪟 | ✅ |
| az | Azure CLI | `winget install Microsoft.AzureCLI` | 🪟 | ✅ |

## Databases

| macOS | Role | Windows equivalent | Where | Status |
| --- | --- | --- | --- | --- |
| DBeaver Community | DB GUI | `winget install DBeaver.DBeaverCommunity` | 🪟 | ✅ |
| psql | postgres CLI | `apt install postgresql-client` | 🐧 | ✅ |
| redis-cli | redis CLI | `apt install redis-tools` | 🐧 | ✅ |
| sqlite3 | sqlite CLI | preinstalled in many distros | 🐧 | ✅ |

## Security & auth

| macOS | Role | Windows equivalent | Where | Status |
| --- | --- | --- | --- | --- |
| SSH (`~/.ssh/config`) | host config | per-identity policy, see `docs/engineering/ssh.md` | 🐧 | ⚖️ |
| SSH private keys | authentication | personal: restore from secure backup **or** generate new; company: do not migrate | 🐧 | 🛠️ |
| GPG | signing | generate new on new machine | 🪟 | 🛠️ |
| Keychain | secrets | Windows Credential Manager / `secret-tool` / WSL keyring | n/a | 🚫 |
| VPN client | corporate VPN | `<REQUEST_FROM_IT>` | 🪟 | 🛠️ |

## Productivity tools

| macOS | Role | Windows equivalent | Where | Status |
| --- | --- | --- | --- | --- |
| Obsidian | notes | `winget install Obsidian.Obsidian` | 🪟 | ✅ |
| FFmpeg | media | `apt install ffmpeg` | 🐧 | ✅ |

## OS-level settings

| macOS | Role | Windows equivalent | Where | Status |
| --- | --- | --- | --- | --- |
| Finder "show extensions" | file behavior | File Explorer "View → File name extensions" | 🪟 | ⚖️ |
| Default apps | file associations | Windows Settings → Default apps | 🪟 | ⚖️ |
| Trackpad / keyboard | input | Windows Settings → Bluetooth & devices | 🪟 | ⚖️ |
| Time Machine | backups | OneDrive / File History / external drive | 🪟 | ⚖️ |