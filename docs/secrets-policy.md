# Secrets & credentials policy

## Rule

This repository must never contain anything that authenticates, identifies,
or authorizes on behalf of the owner beyond what is intentionally public
(for example: a personal email address already used in commit history).

## What must NEVER be committed

| Category | Examples |
| --- | --- |
| Passwords | account passwords, PINs, recovery codes |
| API tokens | GitHub PATs, cloud provider keys, SaaS tokens |
| Private keys | SSH private keys, GPG private keys, signing keys |
| Certificates | TLS certs, code-signing certs, client certs (unless explicitly personal and rotation-safe) |
| Cloud credentials | `~/.aws/credentials`, `~/.config/gcloud/*credentials*`, Azure tokens |
| Kubernetes credentials | `~/.kube/config` contents, service account tokens |
| Docker registry auth | `~/.docker/config.json` `auths` / `credsStore` |
| VPN / corporate | `.mobileconfig` profiles, WireGuard/OpenVPN configs, Zscaler/Cisco configs |
| MDM / device management | JAMF/CrowdStrike/SentinelOne payloads, Intune tokens |
| Internal hostnames | unless already public, redact |
| Usernames on internal systems | corporate SSO, internal Jira/Confluence handles |
| Browser session data | cookies, saved passwords, synced tabs |
| `.env` files | except `templates/.env.example` |

## Placeholder convention

When documenting something that requires a secret, use:

```text
<SECRET>
<TOKEN>
<COMPANY_MANAGED>
<REQUEST_FROM_IT>
<PROJECT_SPECIFIC>
```

This makes the structure obvious in review and prevents accidental
substitution of a real value.

## `.gitignore` policy

The `.gitignore` at the repo root is **defense-in-depth**, not a substitute
for this policy. It catches obvious patterns but cannot reason about
content. Review diffs manually.

## Current `git` history

This repository is **public**. Anything that has been pushed to `origin`
must be considered exposed. Do not retroactively commit secrets; rotate them.

## On departure from a company

Before returning a company-issued machine:

1. Do not copy secrets from that machine into this repo.
2. Do not commit corporate hosts, internal IPs, or VPN endpoints.
3. Do not retain company-managed license files.
4. For tools that the new employer will need to provide (VPN, MDM, internal
   PKI, internal package mirrors), document the *requirement* and mark it
   `<REQUEST_FROM_IT>`.

## On joining a new company

Assume:

- WSL2, virtualization, winget, Windows Terminal, Developer Mode, Docker
  Desktop, and local-admin installation may all be restricted.
- Plan B per capability is documented in `docs/platforms/windows.md`.