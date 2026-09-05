# 0001 — Windows + WSL2 hybrid for Linux-oriented development

Status: Accepted
Date:   2025

## Context

I am moving from a macOS workstation (Apple Silicon, Homebrew + native
terminal tools) to a Dell Windows 11 workstation. My development workload
includes:

- Python development (with `uv`)
- Go development
- Docker / container work
- Terraform / OpenTofu / Ansible
- `kubectl`, `helm`, `k9s`
- Bash automation
- VS Code as the primary editor

Native Windows tooling exists for most of this (winget packages `python`,
`go`, `node`, `kubectl`, `helm`, `terraform`), but several constraints
push back:

- Several tools behave differently on Windows: shell quoting, line endings,
  filesystem semantics (case, permissions, symlinks).
- Many infrastructure CLIs assume a POSIX environment and have a more
  documented Linux install path than a Windows one.
- Docker Desktop on Windows runs containers in WSL2 under the hood anyway.

## Decision

Adopt a **Windows host + WSL2 hybrid**:

- **Windows host owns**: corporate applications, browser, VS Code, Windows
  Terminal, winget, Windows-side utilities. Optionally Docker Desktop.
- **WSL2 owns**: Python, Go, Bash, Git for repositories developed inside
  WSL, SSH for those repositories, Terraform/OpenTofu, kubectl, Helm, k9s,
  and general Linux tooling.

Repositories that are Linux-oriented live inside the WSL2 filesystem
(`~/src/...`) and are accessed from VS Code via **Remote - WSL**.
Repositories that need Windows-native interaction can live on the Windows
side; do not mix.

Git for Windows remains installed for Windows-native workflows but is
**not** the primary Git for WSL-hosted repositories. There is exactly one
canonical `.gitconfig` — the one in this repo, symlinked into WSL2.

## Consequences

Positive:

- Linux dev environment is reproducible from a single distro image.
- Path/file semantics in WSL2 match Linux, matching the rest of the toolchain.
- Docker Desktop + WSL2 integration is well-supported.
- Bash, GNU coreutils, GNU find, GNU grep, GNU sed all behave as expected.

Negative / risks:

- File performance across `/mnt/c` is slow — repositories must live in
  WSL2 (`~/src`), not in `/mnt/c/Users/...`.
- Two Git installations exist; the developer must know which shell is
  running which Git. Mitigated by the rule "WSL repositories use WSL Git".
- WSL2, virtualization, and Developer Mode may be restricted by the new
  employer's IT. Fallbacks documented in `docs/platforms/windows.md`.
- WSL2 is not a hard dependency; if it is unavailable, the architecture
  degrades to native Windows (Decision 0002 covers the package manager).

## Fallbacks

If WSL2 is unavailable:

- Python via winget + `uv` on Windows.
- Go via winget.
- Git via Git for Windows (not in WSL).
- Terraform via winget / HashiCorp zip.
- kubectl / Helm via Windows binaries.
- The boundary between "WSL repos" and "Windows repos" collapses; treat
  everything as Windows-native and document deviations.

## Validation

The validator is profile-aware so it does not require WSL-only tools on
the Windows host or vice versa:

```bash
bash scripts/inventory/validate.sh --profile mac
bash scripts/inventory/validate.sh --profile wsl
bash scripts/inventory/validate.sh --profile windows-host

pwsh scripts/inventory/validate.ps1 -Profile mac
pwsh scripts/inventory/validate.ps1 -Profile wsl
pwsh scripts/inventory/validate.ps1 -Profile windows-host
```