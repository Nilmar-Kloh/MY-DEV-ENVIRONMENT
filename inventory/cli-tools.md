# CLI tools — curated inventory

Source of truth: `bash scripts/inventory/macos.sh` (`inventory/raw/cli-tools.txt`,
gitignored local evidence).

Reading a row: **Current** is live-run evidence. **Decision** uses the
Task-5 vocabulary (`[KEEP]` `[REPLACE]` `[OPTIONAL]` `[COMPANY]`
`[DROP]`, `<USER_REVIEW>`). **Required?** answers whether the Dell/WSL
bootstrap (and therefore validation) blocks on it. **Validate** is the
check command.

Conventions: `[ABSENT][TARGET]` = wanted on the Dell, not on the Mac.
Project-local tools (per-project `pytest`, `uvicorn`) are recreated via
`uv sync`, never migrated as binaries.

## Language tooling

| Tool | Current | Decision | Target | Install | Required? | Validate |
| --- | --- | --- | --- | --- | --- | --- |
| git | DETECTED | [KEEP] | WSL2 + host | `apt install git` / `winget install Git.Git` | yes | `git --version` |
| git-filter-repo | DETECTED | [KEEP] | WSL2 | `uv tool install git-filter-repo` | no | `git-filter-repo --version` |
| gh | DETECTED | [KEEP] | WSL2 + host | `winget install GitHub.cli` / distro pkg | no | `gh --version` |
| go | DETECTED | [KEEP] | WSL2 | go.dev Linux tarball | yes | `go version` |
| node | DETECTED | [KEEP] | WSL2 (`<USER_REVIEW>` host) | distro pkg or `winget install OpenJS.NodeJS.LTS` | no | `node --version` |
| npm | DETECTED | [KEEP] | bundled with node | bundled | no | `npm --version` |
| pnpm | ABSENT | [OPTIONAL] | WSL2 if needed | `corepack enable` or upstream | no | `pnpm --version` |
| yarn | ABSENT | [DROP] | — | — | no | — |
| python3 | DETECTED | [REPLACE] | WSL2, uv-managed | `uv` brings its own Python | yes (via `uv`) | `python3 --version` |
| pip | ABSENT | [DROP] | — | `uv` covers pip needs | no | — |
| pipx | ABSENT | [DROP] | — | `uv tool install` replaces it | no | — |
| uv | DETECTED | [KEEP] | WSL2 | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | yes | `uv --version` |
| pyenv | ABSENT | [DROP] | — | uv covers it | no | — |
| ruff | ABSENT | [TARGET]→[KEEP] | WSL2 | `uv tool install ruff` / per-project | no | `ruff --version` |
| mypy | ABSENT | [OPTIONAL] | WSL2 per-project | per-project | no | `mypy --version` |
| pytest | DETECTED | [KEEP] | per-project (recreated) | `uv sync` per project | no | `pytest --version` |
| black | ABSENT | [DROP] | — | ruff format replaces it | no | — |
| isort | ABSENT | [DROP] | — | ruff replaces it | no | — |
| uvicorn | DETECTED | [KEEP] | per-project (recreated) | `uv sync` per project | no | `uvicorn --version` |

## Containers

| Tool | Current | Decision | Target | Install | Required? | Validate |
| --- | --- | --- | --- | --- | --- | --- |
| docker | DETECTED | [KEEP] | Windows host + WSL2 | Docker Desktop if approved, else fallback (see `inventory/containers.md`) | yes | `docker --version` |
| docker compose | DETECTED | [KEEP] | bundled | bundled | yes | `docker compose version` |
| colima | DETECTED | [DROP] | — | role replaced by WSL2 | no | — |
| lima (`limactl`) | DETECTED | [DROP] | — | Colima backend; same as above | no | — |
| podman | ABSENT | [DROP] | — | fallback only | no | — |

## Infrastructure

| Tool | Current | Decision | Target | Install | Required? | Validate |
| --- | --- | --- | --- | --- | --- | --- |
| kubectl | ABSENT | [TARGET]→[KEEP] | WSL2 | kubernetes.io docs | no | `kubectl version --client` |
| helm | ABSENT | [TARGET]→[KEEP] | WSL2 | helm.sh docs | no | `helm version --short` |
| k9s | ABSENT | [OPTIONAL] | WSL2 | k9scli.io | no | `k9s version` |
| terraform | ABSENT | [TARGET]→[KEEP] | WSL2 | developer.hashicorp.com | no | `terraform --version` |
| tofu | ABSENT | `<USER_REVIEW>` | WSL2 if adopted | opentofu.org | no | `tofu --version` |
| ansible | DETECTED | [KEEP] | WSL2 | distro package | no | `ansible --version` |
| packer | ABSENT | [OPTIONAL] | WSL2 if needed | developer.hashicorp.com | no | `packer --version` |

Only one of terraform/tofu should become the default. `<USER_REVIEW>`:
pick terraform (incumbent ecosystem) vs tofu (open fork).

## Cloud CLIs

| Tool | Current | Decision | Target | Install | Required? | Validate |
| --- | --- | --- | --- | --- | --- | --- |
| aws | ABSENT | [TARGET] | host or WSL2 per employer SSO | `winget install Amazon.AWSCLI` | no | `aws --version` |
| gcloud | ABSENT | [TARGET] | host or WSL2 per employer SSO | `winget install Google.CloudSDK` | no | `gcloud --version` |
| az | ABSENT | [TARGET] | host or WSL2 per employer SSO | `winget install Microsoft.AzureCLI` | no | `az --version` |

Install at most what the new employer actually uses. Credentials are
never committed; see `docs/secrets-policy.md`.

## Databases

| Tool | Current | Decision | Target | Install | Required? | Validate |
| --- | --- | --- | --- | --- | --- | --- |
| psql | ABSENT | [TARGET] | WSL2 | distro package | no | `psql --version` |
| redis-cli | ABSENT | [TARGET] | WSL2 | distro package | no | `redis-cli --version` |
| sqlite3 | DETECTED | [OPTIONAL] | WSL2 if needed | distro package | no | `sqlite3 --version` |
| mongosh | ABSENT | [DROP] | — | — | no | — |

## Modern Unix replacements

| Tool | Current | Decision | Target | Install | Required? | Validate |
| --- | --- | --- | --- | --- | --- | --- |
| ffmpeg | DETECTED | [KEEP] | WSL2 | distro package | no | `ffmpeg -version` |
| jq | DETECTED | [KEEP] | WSL2 | distro package | no | `jq --version` |
| bat | DETECTED | [KEEP] | WSL2 | distro package | no | `bat --version` |
| eza | DETECTED | [KEEP] | WSL2 | distro package or upstream | no | `eza --version` |
| fd | ABSENT | [TARGET]→[KEEP] | WSL2 | distro package or upstream | no | `fd --version` |
| ripgrep | ABSENT | [TARGET]→[KEEP] | WSL2 | distro package or cargo | no | `rg --version` |
| fzf | DETECTED | [KEEP] | WSL2 | distro package or git install | no | `fzf --version` |
| zoxide | ABSENT | [OPTIONAL] | WSL2 if wanted | upstream | no | `zoxide --version` |
| starship | DETECTED | [KEEP] | WSL2 | starship.rs installer | no | `starship --version` |
| tmux | DETECTED | [KEEP] | WSL2 | distro package | no | `tmux -V` |
| mkcert | DETECTED | [KEEP] | WSL2 | upstream release | no | `mkcert --version` |

Note: the Brewfile declares `fd` and `ripgrep` but the live run shows
both absent (bundle not applied or formulae unlinked). They remain
`[TARGET]`: install on the Dell rather than fixing the Mac.

## Editor CLIs

| Tool | Current | Decision | Target | Install | Required? | Validate |
| --- | --- | --- | --- | --- | --- | --- |
| code | DETECTED | [KEEP] | Windows host | `winget install Microsoft.VisualStudioCode` | yes (host) | `code --version` |
| cursor | ABSENT (app present, not in PATH) | [OPTIONAL] | — | — | no | — |
| opencode | DETECTED | [KEEP] | WSL2 | upstream download | no | `opencode --version` |

## SSH / shell

| Tool | Current | Decision | Target | Install | Required? | Validate |
| --- | --- | --- | --- | --- | --- | --- |
| ssh | DETECTED | [KEEP] | WSL2 + host | system | yes | `ssh -V` |
| ssh-add | DETECTED | [KEEP] | WSL2 + host | system (OpenSSH) | no | `ssh-add -l` |
| scp | DETECTED | [KEEP] | WSL2 + host | system | no | `scp` |

## Build toolchains

| Tool | Current | Decision | Target | Install | Required? | Validate |
| --- | --- | --- | --- | --- | --- | --- |
| make | DETECTED | [KEEP] | WSL2 | build-essential | no | `make --version` |
| gcc/clang | DETECTED | [KEEP] | WSL2 | build-essential | no | `gcc --version` |
| cmake | ABSENT | [OPTIONAL] | per-project | distro package | no | `cmake --version` |
| java (stub) | DETECTED | [DROP] | — | Apple stub; real JDK per-project only | no | — |
| ruby (system 2.6) | DETECTED | [DROP] | — | macOS system Ruby; version manager only if needed | no | — |
| gem/bundler | DETECTED | [DROP] | — | follow Ruby | no | — |
| cargo/rustc/rustup | ABSENT | [DROP] | — | not used | no | — |

## Validation

```bash
bash scripts/inventory/validate.sh --profile wsl
```
