# Windows-specific configuration

This directory holds Windows-host-only configuration that is not part of
`configs/windows/powershell/` (which is for shell-side configuration).

Currently empty. Add files here only when:

- a setting applies ONLY to Windows host (not WSL2's Linux),
- it cannot be expressed as a portable dotfile.

Example candidates: registry tweaks, Windows Terminal profiles
(`settings.json`), taskbar layout exports, scheduled task definitions.

The winget package manifest, when generated, lives here as
`packages.txt`:

```powershell
winget export -o platforms\windows\packages.txt
```

Review the output, then commit.