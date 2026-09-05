# Containers — inventory

Source of truth: `bash scripts/inventory/macos.sh` (`inventory/raw/containers.txt`).

Tag vocabulary: see `inventory/README.md`.

## Currently present on the Mac (DETECTED)

| Component | Status | Notes |
| --- | --- | --- |
| Docker CLI (`docker` 29.6.1) | [DETECTED] | primary runtime backend on the Mac |
| docker compose | [DETECTED] | bundled with Docker CLI |
| Colima 0.10.3 | [DETECTED] | macOS Linux-VM backend |
| Lima 2.1.4 (`limactl`) | [DETECTED] | underlying VM manager behind Colima |

`docker` is present. The GUI ("Docker Desktop") is not in
`/Applications` per the live inventory — the runtime may run headless
or via Colima. Confirm with `docker context ls` on the source machine.

## Curation decision

| Component | Decision | Rationale |
| --- | --- | --- |
| Docker CLI + Compose | [KEEP] | core workflow; target is Docker Desktop (if approved) on Windows with WSL2 backend |
| Colima / Lima | [DROP] | macOS-specific VM infrastructure. Its role (Linux VM for containers) is replaced by WSL2 on the Dell. Keep documented here as fallback knowledge only. |

## NOT currently on the Mac (ABSENT)

| Component | Status | Notes |
| --- | --- | --- |
| Docker Desktop app | [ABSENT] (verify before claiming) | not in `/Applications`; may run headless — confirm via `docker context ls` |
| Podman | [ABSENT] | daemonless runtime — not used |
| Buildx | [DETECTED] | bundled plugin in modern Docker |

## What is NOT migrated

- Docker Desktop license / signed-in Docker Hub account
- Container images in local registries (re-pull or rebuild)
- `~/.docker/config.json` — may contain registry auth. See
  `docs/secrets-policy.md`.
- Any volume data that contains proprietary company data

## Windows target (TARGET)

**Default path:** Docker Desktop on Windows, with WSL2 backend. This
preserves Compose files verbatim and matches current macOS behavior.

```powershell
winget install Docker.DockerDesktop
```

After install:

- Enable WSL2 backend in Docker Desktop settings.
- Confirm Docker Desktop → Settings → Resources → WSL Integration
  exposes the development distro.

**Fallback if Docker Desktop is not licensed by the new employer:**

| Option | Notes |
| --- | --- |
| Rancher Desktop | Free, supports both containerd and moby engines, WSL2-native. |
| Podman Desktop | Daemonless, supports WSL2 backend. Slightly different CLI surface. |
| WSL2 + native Linux Docker engine | Manual; powerful; less convenient. |

Do not assume Docker Desktop is permitted. Confirm with new-employer
IT.

## Validation

```bash
docker run --rm hello-world
docker compose version
```