# Containers — inventory template

Source of truth: `bash scripts/inventory/macos.sh` (`inventory/raw/containers.txt`).

## Currently used on macOS

| Component | Role | Status |
| --- | --- | --- |
| Docker Desktop | primary container runtime | [essential] |
| Docker CLI | `docker` command | bundled with Docker Desktop |
| Compose | multi-container orchestration | bundled / plugin |
| Buildx | extended build capabilities | bundled / plugin |
| Colima | alternate Linux VM backend | optional |
| Podman | alternate daemonless runtime | optional |

Verify by running:

```bash
docker --version
docker compose version
docker buildx version
docker context ls
```

## What is NOT migrated

- Docker Desktop license / signed-in Docker Hub account
- Container images in local registries (re-pull or rebuild)
- `~/.docker/config.json` — may contain registry auth. See `docs/secrets-policy.md`.
- Any volume data that contains proprietary company data

## Windows target

**Default path (recommended):** Docker Desktop on Windows, with WSL2 backend.
This preserves Compose files verbatim and matches current macOS behavior.

```powershell
winget install Docker.DockerDesktop
```

After install:

- Enable WSL2 backend in Docker Desktop settings (default in current versions)
- Confirm Docker Desktop's "Settings → Resources → WSL Integration" exposes
  the development distro

**Fallback if Docker Desktop is not licensed by the new employer:**

| Option | Notes |
| --- | --- |
| Rancher Desktop | Free, supports both containerd and moby engines, WSL2-native. |
| Podman Desktop | Daemonless, supports WSL2 backend. Slightly different CLI surface. |
| WSL2 + native Linux Docker engine | Manual, but eliminates Docker Desktop dependency. |

Do not assume Docker Desktop is permitted. Confirm with new-employer IT.

## Validation

```bash
docker run --rm hello-world
docker compose version
```