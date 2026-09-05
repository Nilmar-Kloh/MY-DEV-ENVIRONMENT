# Pre-return MacBook checklist

Use this checklist in the last week(s) before returning the company-issued
MacBook. Every box should be checked and dated, or explicitly skipped with
a reason.

## 1. Personal repositories

- [ ] All personal repositories pushed to their remotes (GitHub/GitLab).
- [ ] All personal branches pushed.
- [ ] No unpushed tags remain.
- [ ] No stashes contain company code or credentials.

```bash
# for each personal repo
git status
git fetch --all --prune
git push --all
git push --tags
```

## 2. Capture the inventory

Run the inventory script and commit the sanitized output.

- [ ] `bash scripts/inventory/macos.sh`
- [ ] Review `inventory/raw/` files.
- [ ] Transfer verified entries into `inventory/*.md`.
- [ ] Remove company-only items.
- [ ] Commit.

```bash
git add inventory/
git commit -m "docs(inventory): capture outgoing macOS inventory"
```

## 3. Capture shell configuration

- [ ] Confirm `configs/shell/zshrc` and friends reflect what is actually
      sourced today.
- [ ] Confirm `~/.zshrc`, `~/.tmux.conf`, `~/.gitconfig` are symlinks to
      this repo (or update the bootstrap step).
- [ ] Decide whether to keep `aliases.zsh`/`exports.zsh`/`functions.zsh`
      as-is or to refactor (see `docs/platforms/shared.md`).
- [ ] Do NOT copy `.zsh_history`.

## 4. Capture Git configuration safely

- [ ] `git config --global --list > inventory/raw/git-config.txt`.
- [ ] Manually redact credential-related values before committing.
- [ ] Confirm `configs/git/gitconfig` matches the live configuration.

## 5. Capture SSH configuration safely

- [ ] `bash scripts/inventory/macos.sh` (the SSH section) produces a
      structural summary at `inventory/raw/ssh.md` (counts only — no
      hostnames, IPs, fingerprints, or key contents).
- [ ] Confirm no private keys are referenced in committed files.
- [ ] Confirm no company host stanzas remain in any personal SSH config
      you carry forward (review by hand on the source machine; the
      script cannot do this for you).
- [ ] Personal keys: back up via a secure personal channel (never this
      repo). See `docs/engineering/ssh.md` for the identity-based
      policy.

## 6. Capture editor configuration

- [ ] `code --list-extensions > inventory/raw/vscode-extensions.txt`.
- [ ] Compare against `configs/vscode/extensions.json`. Resolve drift.
- [ ] Do NOT copy `~/Library/Application Support/Code/User/`.

## 7. Capture environment variables (names only)

- [ ] Confirm `inventory/raw/env-variable-names.txt` exists.
- [ ] For any variable that documents a requirement (e.g.,
      `GITHUB_TOKEN`, `DATABASE_URL`), make sure the corresponding
      `templates/.env.example` documents its purpose.
- [ ] No values committed.

## 8. Capture language/runtime versions

- [ ] `inventory/raw/languages.txt` exists from the inventory script.
- [ ] `uv tool list > inventory/raw/uv-tools.txt` (if relevant).
- [ ] `ls -1 "$HOME/go/bin" > inventory/raw/go-bin.txt`.

## 9. Container/tooling state

- [ ] `docker context ls` reviewed.
- [ ] No company registry credentials in `~/.docker/config.json`.
- [ ] Docker Desktop license status understood (do not copy).

## 10. Company-managed dependencies

For each tool the new employer will need to provide, document:

- tool name
- purpose
- whether it is company-managed on the new machine
- whether to `<REQUEST_FROM_IT>`

```text
| Tool                | Purpose              | Action on new machine |
| ------------------- | -------------------- | --------------------- |
| VPN client          | internal network     | <REQUEST_FROM_IT>     |
| Corporate SSO       | auth                 | <REQUEST_FROM_IT>     |
| Internal PKI certs  | TLS inspection       | <REQUEST_FROM_IT>     |
| MDM agent           | device management    | <REQUEST_FROM_IT>     |
| License server URLs | software activation  | <REQUEST_FROM_IT>     |
```

## 11. Local files that legitimately need migration

For each personal file:

```text
| File                | Why it needs to migrate | Method |
| ------------------- | ----------------------- | ------ |
| ~/.gitconfig.personal | used by some repos only | export selectively, never commit |
```

If a file is needed but contains sensitive content, transfer it manually
through a channel that does NOT include the public repository.

## 12. Clone the repository to a personal backup

- [ ] Clone `MY-DEV-ENVIRONMENT` to a personal, non-company-controlled
      system (laptop at home, personal NAS, encrypted USB).
- [ ] Verify the clone has the latest commit and matches the remote.

```bash
git clone git@github.com:Nilmar-Kloh/MY-DEV-ENVIRONMENT.git ~/personal/MY-DEV-ENVIRONMENT
```

## 13. Verify repository is self-sufficient

- [ ] On the personal backup, can `bash scripts/inventory/validate.sh
      --profile mac` run? (It depends only on standard tools.)
- [ ] On the personal backup, does `docs/migration/windows-arrival-checklist.md`
      contain everything needed to bootstrap a Windows machine without
      access to the Mac?

## 14. Final data hygiene on the Mac

- [ ] Empty Trash.
- [ ] Sign out of personal accounts if the Mac is shared.
- [ ] Disable any personal iCloud sync that may push data to the Mac.
- [ ] Confirm no personal photos, notes, or documents in iCloud-synced
      folders.
- [ ] Disconnect any personal Bluetooth pairings.

## 15. Return-day actions

- [ ] Sign out of iCloud / Apple ID.
- [ ] Sign out of any personal browser sessions.
- [ ] Reset NVRAM if required by IT.
- [ ] Hand back the machine.