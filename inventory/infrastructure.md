# Infrastructure & cloud tooling — inventory template

Source of truth: `bash scripts/inventory/macos.sh` (`inventory/raw/cli-tools.txt`)
plus manual addition for items the script may miss.

Tags: `[essential] [useful] [optional] [company] [excluded]`

## Kubernetes

| Tool | Purpose | Install on Windows |
| --- | --- | --- |
| kubectl | cluster control | WSL2: `brew install kubectl` or download from kubernetes.io |
| helm | package manager | WSL2: `brew install helm` |
| k9s | TUI dashboard | WSL2: `brew install k9s` |
| kubeconfig | cluster auth | NEVER commit. See `docs/secrets-policy.md`. |

## IaC

| Tool | Purpose | Install on Windows |
| --- | --- | --- |
| terraform | IaC | WSL2: install per HashiCorp docs |
| tofu (OpenTofu) | IaC fork | WSL2: install per opentofu.org |
| ansible | config management | WSL2: `apt install ansible` or `brew install ansible` |
| packer | machine images | optional |

## Cloud CLIs

| Tool | Notes |
| --- | --- |
| aws | `~/.aws/` is NEVER committed. Credentials handled outside this repo. |
| gcloud | same |
| az | same |

## Secrets handling

- `~/.kube/config` — never committed. Use a secrets manager or manual restore.
- `~/.aws/credentials` — never committed.
- `~/.config/gcloud/application_default_credentials.json` — never committed.
- Cloud SSO sessions — re-authenticate on the new machine.

## Validation

```bash
kubectl version --client
helm version --short
terraform version
tofu version
aws --version
```