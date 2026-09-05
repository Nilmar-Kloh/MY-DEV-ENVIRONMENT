# Engineering philosophy

This repository encodes the principles that guide every configuration and
migration decision in it.

1. **Git is the source of truth for configuration, not secrets.**
   Configuration belongs here. Credentials, tokens, and private keys do not.

2. **Reconstruct environments, do not copy machines.**
   A clean rebuild from manifests and dotfiles is preferred over a disk image
   or migration tool. Reconstruction forces clarity about what is required.

3. **Prefer declarative manifests over screenshots or memory.**
   A `Brewfile`, a `winget` export, or a Markdown table outlives any
   screenshot and is reviewable.

4. **Prefer portable configuration where practical.**
   If a setting is the same on macOS, Linux, and Windows, store it once in
   `configs/shared/` and reference it. Platform-specific configuration is
   isolated in `configs/macos/` or `configs/windows/`.

5. **Keep OS-specific configuration isolated.**
   A shell file that hardcodes `/opt/homebrew/bin` does not belong on Windows.
   A PowerShell profile does not belong on macOS.

6. **Minimize package-manager sprawl.**
   One package manager per platform unless there is a clear technical reason
   to add another. Winget on Windows, Homebrew on macOS, the Linux distro's
   package manager inside WSL2.

7. **Avoid unnecessary frameworks.**
   No Ansible, Chezmoi, Nix, GNU Stow, or similar unless the project grows to
   require them. Plain shell scripts + manifests + dotfiles is the default.

9. **Keep authentication manual.**
   Until a secrets manager is chosen, re-authentication on each new machine
   is the policy.

10. **Do not reproduce company-owned material.**
    Software names may be referenced; binaries, certificates, profiles, and
    configuration values belonging to a current/former employer do not.

11. **Document why decisions were made.**
    Architectural decisions live in `docs/decisions/` as lightweight ADRs.

12. **Every automation has a validation method.**
    `scripts/inventory/validate.sh` and equivalents verify the world matches
    the plan.