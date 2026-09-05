# 0002 — winget as the primary Windows package manager

Status: Accepted
Date:   2025

## Context

The Windows ecosystem offers multiple package managers:

- **winget** — Microsoft's official CLI. Ships with App Installer on Windows
  11 and modern Windows 10. Manifests in a YAML-like format. Community
  contributions via `winget-pkgs`.
- **Scoop** — user-local, single command to install developer tools.
- **Chocolatey** — system-wide, large community catalog, older than winget.

Per `docs/philosophy.md` (principle 6), the project minimizes package-manager
sprawl. Using all three would multiply maintenance.

## Decision

Adopt **winget** as the primary Windows package manager. Do not introduce
Scoop or Chocolatey by default.

Document Scoop only as a fallback when winget cannot adequately provide a
required tool. Document Chocolatey only for legacy or enterprise-managed
tooling.

Within WSL2, use the Linux distribution's native package manager
(`apt` on Ubuntu, `dnf` on Fedora, etc.) plus language-specific tooling
(`uv`, `go install`, `pipx`). Do not attempt to manage the WSL development
environment from Windows-side winget.

## Consequences

Positive:

- Single package manager on Windows host. Less to remember.
- Manifests are simple text files (`*.winget` export or manual YAML).
- winget is preinstalled on most new Windows machines.
- No extra system service or PATH prefix required.

Negative / risks:

- winget manifests lag behind fast-moving projects (e.g., some CLI tools
  may not have a current winget id; in that case use direct download).
- Some packages install to user profile (`%LOCALAPPDATA%`) and some to
  Program Files. Behavior is package-specific.
- winget requires App Installer to be present and current; corporate
  policies may break it.

## Procedure

Generate a manifest:

```powershell
winget export -o inventory/raw/winget-export.json
```

Review, sanitize, commit a curated version to `platforms/windows/packages.txt`
(see `docs/platforms/windows.md`).

Install:

```powershell
winget import -i platforms/windows/packages.txt --ignore-versions
```

`--ignore-versions` is used so the file does not have to be updated every
time a package bumps.

## Fallback

If a specific tool is unavailable via winget:

- Try direct download from the upstream project.
- If a CLI tool is needed and only available via Scoop, document the
  exception in `docs/platforms/windows.md` rather than adding Scoop
  wholesale.