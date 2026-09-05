# Docker

## Purpose

Docker is used for containerized development, Compose-based stacks, and
local Kubernetes-adjacent experimentation.

## Current macOS setup

| Component | Version source |
| --- | --- |
| Docker Desktop | installed on the host (license belongs to current employer — do NOT migrate) |
| Engine | Docker Desktop-managed |
| Compose | bundled v2 (`docker compose`) |
| Buildx | bundled plugin |

Capture versions with:

```bash
docker --version
docker compose version
docker buildx version
docker context ls
```

## Windows target

Per `docs/decisions/0001-windows-vs-wsl2.md`:

```powershell
winget install Docker.DockerDesktop
```

Then in Docker Desktop → Settings → Resources → WSL Integration:
enable the development distro. From WSL2:

```bash
docker --version
docker compose version
docker run --rm hello-world
```

This matches the macOS workflow exactly.

## Fallback if Docker Desktop is unavailable

| Option | Notes |
| --- | --- |
| Rancher Desktop | Free. Supports containerd and dockerd (moby) engines. WSL2-native. |
| Podman Desktop | Daemonless. CLI diverges from `docker` in places (`podman compose`). |
| Native WSL2 engine | Manual. Powerful. Less user-friendly. |

Document the actual choice in `inventory/containers.md` once decided.

## What is NOT migrated

- Docker Desktop license / activation
- Saved `docker login` sessions (`~/.docker/config.json` `auths` section)
- Local image registries that contain proprietary content
- Volume data with sensitive content

## Compose files

`docker-compose.yml` / `compose.yml` files are project-level, not stored
in this repo. They move with the source code of each project.

## Validation

```bash
docker run --rm hello-world
docker compose version
docker buildx version
```