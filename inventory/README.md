# Inventory

This directory holds the **reviewed inventory** of my development
environment. It is the canonical answer to: *what do I depend on, and
how is it currently installed?*

Inventory is captured by running a script on the live machine. Nothing in
this directory should be hand-edited from memory — the source of truth
is the script output, reviewed and committed.

## Two levels: reviewed vs raw

| Level | Path | Purpose | Git status |
| --- | --- | --- | --- |
| **Reviewed** | `inventory/*.md` | Sanitized, classified Markdown tables. The committed source of truth. | **Committed** |
| **Raw** | `inventory/raw/` | Timestamped machine-specific evidence captured by the inventory scripts. Includes version strings, hostname, application list, structural SSH summary, etc. | **Local only** (gitignored) |

`inventory/raw/` is treated as **local-sensitive evidence**. Even though
the scripts redact aggressively (no private keys, no tokens, no
hostnames, no IPs, no fingerprints, no file sizes that fingerprint key
types), raw output still contains machine-specific information
(hostname, version strings, exact installed packages) that should not
leave the workstation that produced it.

Review the raw output, then transcribe the relevant classifications
into `inventory/*.md` and commit those.

## Classification tags

Every item in the committed inventory is tagged:

- **`[DETECTED]`** — confirmed by the inspection script on a real run.
  Only mark after running the script.
- **`[TARGET]`** — target for the new (Windows) workstation. The
  intended post-migration state.
- **`[OPTIONAL]`** — nice to have, not required for daily work.
- **`[COMPANY]`** — provided/managed by corporate IT. Do NOT migrate.
- **`[PERSONAL]`** — personal, owned by you. Safe to reinstall on
  personal hardware.
- **`[EXCLUDED]`** — intentionally not migrating (license, duplicate,
  non-portable, etc.).

A tool's status on the Mac (`[DETECTED]`) and its status on the Dell
(`[TARGET]`) are independent. `[DETECTED]` does NOT imply `[TARGET]`,
and `[TARGET]` does NOT require `[DETECTED]` (e.g., `terraform` is a
target even if it is not currently installed on the Mac).

## Files

- `applications.md` — GUI applications in `/Applications` (Mac) or installed programs (Windows)
- `cli-tools.md` — important CLI tools in `PATH`
- `languages.md` — language runtimes and their managers
- `editors.md` — editor/IDE configuration scope (VS Code, Cursor, JetBrains, Neovim)
- `containers.md` — Docker / Colima / Podman / Compose / Buildx
- `infrastructure.md` — kubectl, Helm, Terraform, OpenTofu, Ansible, cloud CLIs
- `system-settings.md` — OS-level configuration worth preserving

## What is intentionally NOT here

- Project-specific virtual environments (`.venv/`)
- Build artifacts, caches, `node_modules/`
- Secrets, tokens, certificates, SSH private keys
- `zsh_history` / shell history
- Anything in `inventory/raw/` (kept local only)

## See also

- `docs/migration/overview.md` — how inventory feeds the migration
- `scripts/inventory/` — the scripts that produce this content