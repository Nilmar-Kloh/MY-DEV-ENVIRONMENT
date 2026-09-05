# Languages & runtimes — inventory template

Source of truth: `bash scripts/inventory/macos.sh` output (`inventory/raw/languages.txt`).

Tags: `[essential] [useful] [optional] [managed] [company] [excluded]`

## Currently used on macOS

| Language | Manager | Version intent | Pin policy | Notes |
| --- | --- | --- | --- | --- |
| Python | brew (`python@3.14`) + uv | stable | uv per-project | No system-wide pin. uv handles project-level resolution. |
| Go | brew (`go`) | stable | Homebrew formula | `Brewfile` does not pin a patch version. |
| Node | brew (`node`) | stable | Homebrew formula | `Brewfile` does not pin a major. |
| npm | bundled | whatever Node ships | n/a | |
| pnpm | brew/manual | latest | optional | |
| Rust | (likely not currently used) | — | — | Add row when needed. |
| Ruby | (likely not currently used) | — | — | Add row when needed. |
| Java | (likely not currently used) | — | — | Add row when needed. |
| .NET | (likely not currently used) | — | — | Add row when needed. |

## Capture commands

```bash
python3 --version
go version
node --version
npm --version
pnpm --version
uv --version
```

## Python toolchain

| Tool | Purpose | Manager |
| --- | --- | --- |
| uv | Python package + project management | brew → uv tool / per-project |
| ruff | linter + formatter | uv tool / per-project |
| mypy / pyright | type checking | uv tool / per-project |
| pytest | testing | uv dev / per-project |
| uvicorn | ASGI dev server | per-project |
| black | formatter | optional (ruff replaces) |

Conventions (see `docs/engineering/python.md`):

- Project-level Python is managed by `uv`, not by the system Python.
- System Python exists for `uv` itself and for bootstrapping.
- Virtual environments are NOT migrated; they are recreated.

## Go toolchain

See `docs/en/engineering/go.md` (already in repo).

| Tool | Purpose |
| --- | --- |
| gopls | language server |
| govulncheck | vulnerability scanning |
| goimports | import organization |
| staticcheck | static analysis |
| dlv | debugging |

## Node toolchain

| Tool | Purpose |
| --- | --- |
| node | runtime |
| npm | package manager |
| pnpm | alternate package manager |

## Windows layout

| Language | Windows host | WSL2 |
| --- | --- | --- |
| Python | — | uv-managed |
| Go | — | brew-style installer (golang.org tarball) |
| Node | winget `OpenJS.NodeJS.LTS` | optional nvm |
| Rust | rustup-init (winget) | optional rustup |

## Validation

```bash
bash scripts/inventory/validate.sh
```