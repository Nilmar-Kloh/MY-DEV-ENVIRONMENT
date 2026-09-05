# Infrastructure & cloud tooling — inventory

Source of truth: `bash scripts/inventory/macos.sh` (`inventory/raw/cli-tools.txt`)
plus manual addition for items the script may miss.

Tag vocabulary: see `inventory/README.md`.

Important: the live inventory reports **none** of these tools as
detected on the current Mac. They are all `[TARGET]` for the new Dell
workstation, not `[DETECTED]` on the outgoing Mac.

## Kubernetes

| Tool | Status | Notes |
| --- | --- | --- |
| kubectl | [ABSENT][TARGET] | install per kubernetes.io |
| helm | [ABSENT][TARGET] | install per helm.sh |
| k9s | [ABSENT][TARGET] | install per k9scli.io |
| kubeconfig | [EXCLUDED] | NEVER commit. See `docs/secrets-policy.md`. |

## IaC

| Tool | Status | Notes |
| --- | --- | --- |
| terraform | [ABSENT][TARGET] | install per developer.hashicorp.com |
| tofu (OpenTofu) | [ABSENT][TARGET] | install per opentofu.org |
| ansible | [DETECTED][TARGET] | brew on Mac; distro pkg on WSL2 |
| packer | [ABSENT][OPTIONAL] | install per developer.hashicorp.com |

## Cloud CLIs

| Tool | Status | Notes |
| --- | --- | --- |
| aws | [ABSENT][TARGET] | `winget install Amazon.AWSCLI` |
| gcloud | [ABSENT][TARGET] | `winget install Google.CloudSDK` |
| az | [ABSENT][TARGET] | `winget install Microsoft.AzureCLI` |

These were absent on the live Mac. Do not represent them as currently
installed.

## Secrets handling

- `~/.kube/config` — never committed. Use a secrets manager or manual
  restore.
- `~/.aws/credentials` — never committed.
- `~/.config/gcloud/application_default_credentials.json` — never
  committed.
- Cloud SSO sessions — re-authenticate on the new machine.

## Validation

```bash
bash scripts/inventory/validate.sh --profile wsl
```