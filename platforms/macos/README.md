# macOS-specific configuration

This directory is reserved for macOS-only configuration that does not
belong in `configs/shell/` (which is zsh-specific and may eventually be
shared with WSL2's zsh).

Currently empty by design. Add files here only when:

- a setting applies ONLY to macOS (not to WSL2's Linux),
- it has no Windows equivalent worth documenting in `configs/windows/`.

Example candidates: macOS launchd plists, macOS-specific defaults
writes, Spotlight configuration, Keychain access wrappers.