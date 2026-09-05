# CLI tools — inventory template

Source of truth: `bash scripts/inventory/macos.sh` output (`inventory/raw/cli-tools.txt`).
Run it on the current Mac to populate this file.

Tags:

- `[essential]` — required
- `[useful]` — improves workflow
- `[optional]` — nice to have
- `[managed]` — installed via Brewfile (declared in `Brewfile`)
- `[company]` — corporate-managed, do not migrate
- `[excluded]` — intentional non-migration

## Detected / managed on macOS

<!--
The script captures a curated set, not the full PATH. Below are the
known items based on the repo's Brewfile. Verify by running the script.
-->

| Tool | Tag | Detected | Installed via | Notes |
| --- | --- | --- | --- | --- |
| git | [essential] | yes | Xcode CLT / brew | Universal. |
| git-filter-repo | [useful] | yes (Brewfile) | brew | History rewriting. |
| gh | [essential] | yes (Brewfile) | brew | GitHub CLI. |
| go | [essential] | yes (Brewfile) | brew | Language runtime. |
| python@3.14 | [essential] | yes (Brewfile) | brew | Python runtime. |
| uv | [essential] | yes (Brewfile) | brew | Python packaging. |
| pipx | [useful] | yes | brew | App-style pip installs. |
| node | [useful] | yes (Brewfile) | brew | Node runtime. |
| npm | [useful] | yes | bundled | Node package manager. |
| pnpm | [optional] | maybe | brew/pnpm | Fast Node package manager. |
| docker | [essential] | yes | Docker Desktop | Container runtime. |
| kubectl | [essential] | maybe | brew | Kubernetes CLI. |
| helm | [useful] | maybe | brew | Kubernetes package manager. |
| terraform / tofu | [essential] | maybe | brew | IaC. |
| ansible | [optional] | maybe | brew | Config management. |
| aws / gcloud / az | [useful] | maybe | brew | Cloud CLIs (NOT creds). |
| ffmpeg | [useful] | yes (Brewfile) | brew | Media tooling. |
| jq | [essential] | yes (Brewfile) | brew | JSON CLI. |
| bat | [essential] | yes (Brewfile) | brew | Better cat. |
| eza | [essential] | yes (Brewfile) | brew | Better ls. |
| fd | [useful] | yes (Brewfile) | brew | Better find. |
| ripgrep | [essential] | yes (Brewfile) | brew | Better grep. |
| fzf | [essential] | yes (Brewfile) | brew | Fuzzy finder. |
| starship | [essential] | yes (Brewfile) | brew | Prompt. |
| tmux | [useful] | yes (Brewfile) | brew | Terminal multiplexer. |
| mkcert | [optional] | yes (Brewfile) | brew | Local TLS certs. |
| opencode | [useful] | yes (Brewfile) | brew | AI coding assistant. |

## Path of `$HOME/go/bin`

Tools installed via `go install` land here and are added to `PATH` by
`configs/shell/exports.zsh`. Capture a list with:

```bash
ls -1 "$HOME/go/bin" 2>/dev/null
```

Expected (per `docs/en/engineering/go.md`): `gopls`, `govulncheck`, `goimports`,
`staticcheck`, `dlv`.

## Windows migration

- **winget** handles most replacements (`winget install Git.Git`, etc.)
- **WSL2** hosts the Linux-ported dev tools (Python, Go, Terraform, kubectl, Helm)
- Avoid keeping two parallel `git` configs: see `docs/decisions/0001-windows-vs-wsl2.md`

## Validation

```bash
bash scripts/inventory/validate.sh
```