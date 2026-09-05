# Migration manifest — Mac → Dell/WSL2

Human-reviewable source of truth for the transition. Each row is a
deliberate decision backed by live evidence (`inventory/raw/`,
gitignored) and curated in `inventory/`.

Decision vocabulary: `[KEEP]` recreate · `[REPLACE]` capability
survives, implementation changes · `[OPTIONAL]` useful, non-blocking ·
`[COMPANY]` outgoing-employer, do not migrate · `[DROP]` not worth
recreating · `<USER_REVIEW>` owner decides · `<REQUEST_FROM_IT>`
new-employer equivalent needed.

Required=yes means the validator blocks on it.

## Core toolchain (bootstrap baseline)

| Component | Current | Decision | Target | Install method | Required | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| Git | DETECTED | [KEEP] | WSL2 + host | apt / winget | yes | shared behavior in repo; identity local; platform override per env |
| SSH client | DETECTED | [KEEP] | WSL2 + host | system | yes | per-identity key policy, see `docs/engineering/ssh.md` |
| uv | DETECTED | [KEEP] | WSL2 | astral.sh installer | yes | owns Python provisioning |
| Python | DETECTED (brew) | [REPLACE] | WSL2, uv-managed | via `uv` | yes (via uv) | no system Python pin |
| Go | DETECTED (brew) | [KEEP] | WSL2 | go.dev tarball | yes | version = inventory evidence, not a pin |
| Docker + Compose | DETECTED | [KEEP] | host + WSL2 | Docker Desktop if approved, else fallback | yes | license belongs to employer; confirm |
| VS Code | DETECTED | [KEEP] | host | winget | yes (host) | strip macOS-only keys; Remote-WSL for `~/src` |
| Windows Terminal | — (n/a on Mac) | [REPLACE] | host | winget / Store | yes (host) | replaces iTerm2 |
| WSL2 distro | — (n/a on Mac) | [REPLACE] | WSL2 | `wsl --install` if allowed | yes | replaces Homebrew/Linux-VM role |
| zsh + dotfiles | DETECTED | [REPLACE] | WSL2 | repo `configs/shell/` | no | same files, new `$DEV_ENV_HOME` |

## Daily workflow (non-blocking)

| Component | Current | Decision | Target | Install method | Required | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| gh | DETECTED | [KEEP] | WSL2 + host | winget / distro | no | GitHub CLI |
| git-filter-repo | DETECTED | [KEEP] | WSL2 | `uv tool install` | no | history surgery |
| Node + npm | DETECTED | [KEEP] | WSL2 | distro / winget | no | `<USER_REVIEW>` host copy |
| pytest / uvicorn | DETECTED | [KEEP] | per-project | `uv sync` | no | recreated, never migrated |
| ruff | ABSENT | [KEEP] | WSL2 | `uv tool` / per-project | no | replaces black/isort |
| fd / ripgrep | ABSENT (Brewfile-declared) | [KEEP] | WSL2 | distro / upstream | no | declared but uninstalled on Mac |
| bat / eza / fzf / jq | DETECTED | [KEEP] | WSL2 | distro / upstream | no | modern Unix set |
| ffmpeg | DETECTED | [KEEP] | WSL2 | distro | no | media CLI |
| starship / tmux / mkcert | DETECTED | [KEEP] | WSL2 | upstream / distro | no | prompt, multiplexer, local TLS |
| ansible | DETECTED | [KEEP] | WSL2 | distro | no | config management |
| sqlite3 | DETECTED | [OPTIONAL] | WSL2 if needed | distro | no | macOS-bundled today |
| Obsidian | DETECTED | [KEEP] | host | winget | no | personal notes |
| DBeaver | DETECTED | [KEEP] | host | winget | no | primary DB GUI |
| OpenCode | DETECTED | [KEEP] | WSL2 | upstream | no | Brewfile-declared → deliberate |
| Chrome | DETECTED | [KEEP] | host | per policy | no | personal browser |

## Infrastructure / cloud (all optional for bootstrap)

| Component | Current | Decision | Target | Install method | Required | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| kubectl / helm | ABSENT | [KEEP] | WSL2 | upstream docs | no | install when cluster work starts |
| k9s | ABSENT | [OPTIONAL] | WSL2 | k9scli.io | no | TUI, convenience |
| terraform | ABSENT | [KEEP] | WSL2 | HashiCorp docs | no | `<USER_REVIEW>` vs tofu |
| tofu | ABSENT | `<USER_REVIEW>` | WSL2 if adopted | opentofu.org | no | pick one IaC tool |
| psql / redis-cli | ABSENT | [TARGET] | WSL2 | distro | no | client-only, no data |
| aws / gcloud / az | ABSENT | [TARGET] | host or WSL2 per SSO | winget | no | install only what employer uses |

## Dropped (do not recreate)

| Component | Current | Decision | Target | Install method | Required | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| Colima / Lima | DETECTED | [DROP] | — | — | no | macOS VM infra; WSL2 replaces role |
| pip / pipx / pyenv | ABSENT | [DROP] | — | — | no | `uv` covers all three |
| black / isort | ABSENT | [DROP] | — | — | no | ruff covers both |
| yarn | ABSENT | [DROP] | — | — | no | npm/corepack suffice |
| Ruby system / gem / bundler | DETECTED | [DROP] | — | — | no | macOS-bundled, incidental |
| Java stub | DETECTED | [DROP] | — | — | no | Apple stub; real JDK per-project only |
| cargo / rustc | ABSENT | [DROP] | — | — | no | not used |
| AltTab / Dropover / BetterDisplay | DETECTED | [DROP] | — | — | no | macOS gap-fillers |
| Chrome 2 / WhatsApp | DETECTED | [DROP] | — | — | no | duplicate / phone app |
| Raycast / Rectangle / Keka | DETECTED | [REPLACE] | host | PowerToys / 7-Zip | no | capability survives |
| Cursor / Fork / GitHub Desktop | DETECTED | [OPTIONAL] | host if wanted | upstream / winget | no | `<USER_REVIEW>`: at most one Git GUI |

## Company (do not migrate)

JamfProtect, Kaspersky, GlobalProtect, Splashtop On-Prem, Central de
Software, Setup Manager/Checklist, IBM Aspera suite, Teams,
Outlook/Word/Excel/PowerPoint, OneDrive (corporate), Edge (managed),
VNC Viewer, AnyDesk — all `[COMPANY]`. New-employer equivalents are
`<REQUEST_FROM_IT>`, never installed from old-company artifacts.

## Media / peripherals (all OPTIONAL, none bootstrap)

Premiere, Media Encoder, Resolve + Blackmagic suite, Cavalry, Insta360,
DJI Studio, Blender, OBS, Shutter Encoder, Affinity, Wacom, Contour,
Logi Options+, DisplayLink — personal hardware/software, recreate
individually. See `inventory/applications.md`.

## Counts

```text
KEEP:      ~35 (8 required baseline + ~27 workflow/infra clients)
REPLACE:    7 (Terminal, WSL2 distro, Python-provisioning, zsh env, Raycast→PowerToys, Rectangle→FancyZones, Keka→7-Zip)
OPTIONAL:  ~25 (media, peripherals, secondary editors, k9s, sqlite3, …)
COMPANY:   ~15 (security, VPN, comms, office suite, remote access, …)
DROP:      ~17 (Colima/Lima, pip/pipx/pyenv, black/isort, yarn, system Ruby/Java, cargo, macOS gap-fillers, …)
USER_REVIEW: 4 (Fork vs GitHub Desktop vs neither; terraform vs tofu; host Node copy; Cursor)
```
