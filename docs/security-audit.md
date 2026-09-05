# Security audit

Last review: see `git log -1 --format=%cI` on this file.

This document records the security posture of the repository and any
issues found. It is intentionally short. See `docs/secrets-policy.md`
for the policy.

## Scope

Audit performed by reviewing the repository tree for:

- passwords, tokens, API keys, private keys
- SSH private keys, signing keys, certificate files
- `.env` files with values
- internal hostnames, corporate usernames, internal IPs
- kubeconfig contents, cloud credential files
- browser session data
- proprietary company references

## Method

```bash
# from the repo root
find . -type f -not -path './.git/*' \
  | xargs grep -lI \
      -e 'BEGIN.*PRIVATE' \
      -e 'AKIA[0-9A-Z]{16}' \
      -e 'ghp_[A-Za-z0-9]{20,}' \
      -e 'xox[bpars]-[A-Za-z0-9-]+' \
      -e '-----BEGIN CERTIFICATE-----' \
      2>/dev/null
```

```bash
# broader sweep
grep -rI \
  -e 'password' -e 'secret' -e 'token' -e 'api[_-]key' \
  -e 'BEGIN.*PRIVATE' -e '\.pem' -e '\.key' -e 'kubeconfig' \
  --include='*' . 2>/dev/null \
  | grep -v '.git/' \
  | grep -v '^./docs/secrets-policy.md' \
  | grep -v '^./docs/security-audit.md'
```

## Findings

### Historical / committed artifacts

- `git log -p` shows no occurrences of:
  - private SSH key bodies
  - API tokens
  - kubeconfig contents
  - `.env` files with values
- The personal email `nilmarklohpontes@gmail.com` is present in
  `configs/git/gitconfig`. This is consistent with the repository being
  public and is acceptable.
- No `.aws/`, `.kube/`, `.docker/config.json`, or `*.pem`/`*.key` files
  are tracked.

### Current `.gitignore`

- Now hardened to ignore SSH private keys, kubeconfig, cloud
  credentials, shell history, and generated inventory outputs. See
  `.gitignore` at the repo root.

### Repo-as-public

Because this is a **public** repository on GitHub, anything that has
been pushed to `origin` must be considered exposed. The audit found no
secrets in history, so no rotation is required based on this repo.

### Company material

No company-owned material was found in the repository:

- No `.mobileconfig` profiles
- No corporate VPN configurations
- No internal hostnames
- No MDM payloads
- No license server URLs beyond what is universally public

### Items intentionally documented at the placeholder level

`templates/.env.example` and the inventory documentation use placeholders
(`<SECRET>`, `<TOKEN>`, `<COMPANY_MANAGED>`, `<REQUEST_FROM_IT>`,
`<PROJECT_SPECIFIC>`) per `docs/secrets-policy.md`.

## Recommendations for the user

1. Before returning the MacBook, run `bash scripts/inventory/macos.sh`
   and review `inventory/raw/` to confirm nothing sensitive leaked into
   the inventory output. The script is designed to redact, but always
   review.
2. On the new Windows machine, do not commit SSH private keys. Generate
   fresh ones locally.
3. If signing is desired, store the **public** half under
   `configs/git/signing.pub` (or equivalent) only.
4. Re-run this audit after any significant commit touching
   `configs/`, `inventory/`, or `scripts/`.

## Reporting

If you find a secret in the repo, do NOT push a fix commit that includes
the secret. Instead:

1. Revoke / rotate the secret immediately.
2. Use `git filter-repo` (already listed in the Brewfile) to scrub
   history.
3. Force-push (only if this is a personal repo with no shared
   consumers).