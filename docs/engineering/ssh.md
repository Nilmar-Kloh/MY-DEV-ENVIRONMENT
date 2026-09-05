# SSH

## Purpose

SSH authenticates Git operations, server access, and homelab
administration. SSH **identity** (which key authenticates as whom,
against what) must not cross personal / outgoing-employer /
new-employer boundaries. This document defines one policy per identity
class.

## Policy by identity class

### Personal identity

Covers: personal GitHub / GitLab accounts, personal servers, personal
domains.

```text
Restore from a secure personal backup
OR
generate a new personal key.
```

A legitimate personal key is NOT required to be discarded. Either path
is acceptable:

- **Restore**: copy the private key from a secure personal backup
  (encrypted USB, personal password manager, offline copy) onto the new
  machine with `0600` permissions. Never move it through this public
  repository, chat logs, or unencrypted channels.
- **Generate**: create a fresh key on the new machine and register the
  public half with each service:

```bash
ssh-keygen -t ed25519 -C "<PERSONAL_EMAIL>"
ssh-add ~/.ssh/id_ed25519
```

After either path, verify with `ssh -T git@github.com` (or the
equivalent for the service in use).

### Outgoing-company identity

```text
DO NOT MIGRATE.
DO NOT COPY.
DO NOT RETAIN.
```

Keys, certificates, VPN credentials, tokens, internal host stanzas in
`~/.ssh/config`, and any employer-provisioned SSH material stay with
the outgoing employer. Do not copy them to personal backups, do not
commit them here, do not carry them onto the new machine.

Before returning the Mac, confirm no company host stanzas remain in
any personal SSH config you carry forward. The inventory script
(`bash scripts/inventory/macos.sh`) captures only structural counts —
it never prints hostnames — so this review must be done by hand on the
source machine.

### New-company identity

```text
Generate/provision according to the new employer's security policy.
```

Do not assume:

- key algorithm (ed25519 vs RSA vs sk-backed)
- certificate-based SSH vs static keys
- GitHub Enterprise vs GitLab vs other hosting
- SSO wrapping (`gh auth login`, `glab auth login`, SAML)
- hardware tokens (YubiKey / FIDO2)
- centrally provisioned keys (MDM-pushed, Vault-issued, short-lived)

Ask IT / security for the required flow, then follow it. Record only
the *mechanism name* (e.g. "SSO via `gh auth login`"), never key
material or tokens, in personal notes outside this repo.

### Homelab (personal infrastructure)

Homelab hosts are personal property, so their SSH configuration may
legitimately migrate — but under strict rules:

- Private keys **never** enter this public repository.
- Internal IPs (RFC 1918 ranges, Tailscale/WireGuard addresses) do
  **not** need to be committed.
- Sanitized host **aliases** and non-sensitive configuration (port,
  `IdentityFile` name, multiplexing preferences) may be documented
  separately if useful — as *patterns*, not as live addresses.

Example of an acceptable sanitized pattern (aliases renamed, no real
addresses):

```sshconfig
Host homelab-<ROLE>
    HostName <HOMELAB_HOST>
    User <PERSONAL_USER>
    IdentityFile ~/.ssh/id_ed25519
```

Do not commit the current raw SSH inventory. `inventory/raw/ssh.md`
is local-sensitive evidence (gitignored) and stays on the machine that
produced it.

## `~/.ssh/config` handling on the new machine

- WSL2 and the Windows host each keep their own `~/.ssh/` directory.
  Do not symlink one into the other; permissions and agent sockets
  differ per environment.
- Keep personal stanzas in WSL2 (`~/src/` repos live there).
- Keep any future employer stanzas scoped to employer directories,
  mirroring the Git `includeIf` layout in `docs/engineering/git.md`
  (`~/src/company/` → employer SSH config).

## Validation (no secrets printed)

```bash
ls -l ~/.ssh/          # expect 700 on the directory, 600 on private keys
ssh-add -l             # lists fingerprints of loaded keys, not key material
ssh -T git@github.com  # confirms personal GitHub authentication
```
