# Languages & runtimes — inventory

Source of truth: `bash scripts/inventory/macos.sh` (`inventory/raw/languages.txt`)
plus `inventory/raw/cli-tools.txt`.

Tag vocabulary: see `inventory/README.md`.

## Currently present on the Mac (DETECTED)

| Language | Manager | Mac evidence |
| --- | --- | --- |
| Python | brew (`python@<ver>`) + uv | `inventory/raw/cli-tools.txt` |
| Go | brew (`go`) | `inventory/raw/cli-tools.txt` |
| Node | brew (`node`) | `inventory/raw/cli-tools.txt` |

The Python runtime is `3.14.x` per the live run. The exact version is in
`inventory/raw/languages.txt` and should NOT be hard-coded here.

## Runtimes present but NOT deliberately managed (DROP)

These appear in the live inventory but are macOS-bundled, not
intentionally installed. They are not part of the target environment.

| Language | Status | Evidence | Notes |
| --- | --- | --- | --- |
| Ruby 2.6.10 | [DETECTED][DROP] | `inventory/raw/languages.txt` | macOS system Ruby. Do not migrate; install per-project only if needed. |
| Java (stub) | [DETECTED][DROP] | `inventory/raw/cli-tools.txt` (`java`/`javac` present, empty version) | Apple stub JDK. Do not migrate; install a real JDK per-project only if needed. |

## Languages NOT on the Mac (ABSENT)

| Language | Status | Notes |
| --- | --- | --- |
| Rust / cargo / rustup | [ABSENT] | not in PATH |
| .NET | [ABSENT] | not in PATH |

## Capture commands

```bash
python3 --version
go version
node --version
npm --version
pnpm --version
uv --version
```

## Python toolchain (TARGET)

| Tool | Purpose | Manager |
| --- | --- | --- |
| uv | Python package + project management | `uv tool` or per-project |
| ruff | linter + formatter | per-project |
| mypy / pyright | type checking | per-project |
| pytest | testing | per-project |
| uvicorn | ASGI dev server | per-project |

Conventions:

- Project-level Python is managed by `uv`, not by the system Python.
- System Python exists to bootstrap `uv` itself.
- Virtual environments are NOT migrated; they are recreated.

## Go toolchain (TARGET)

Per `docs/en/engineering/go.md`:

| Tool | Purpose |
| --- | --- |
| gopls | language server |
| govulncheck | vulnerability scanning |
| goimports | import organization |
| staticcheck | static analysis |
| dlv | debugging |

Installed via `go install`; binaries in `$HOME/go/bin` and added to
`PATH`. Capture the current installed list with:

```bash
ls -1 "$HOME/go/bin" 2>/dev/null
```

## Node toolchain (DETECTED, partial)

| Tool | Status | Notes |
| --- | --- | --- |
| node | [DETECTED] | via Brewfile |
| npm | [DETECTED] | bundled |
| pnpm | [ABSENT] | install if needed |

## Windows / WSL layout

| Language | Windows host | WSL2 |
| --- | --- | --- |
| Python | — | uv-managed (preferred) |
| Go | — | upstream Linux tarball |
| Node | `winget install OpenJS.NodeJS.LTS` | optional nvm |
| Rust | rustup-init (`winget`) | optional rustup |

## Validation

```bash
bash scripts/inventory/validate.sh --profile mac
bash scripts/inventory/validate.sh --profile wsl
```