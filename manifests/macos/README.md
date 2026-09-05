# Manifests — macOS

The macOS manifest is the root-level **`Brewfile`**. `brew bundle`
resolves it. No additional manifest is needed at present.

To regenerate a curated manifest from the current machine:

```bash
brew bundle dump --file=Brewfile --force
```

To bootstrap from it:

```bash
bash scripts/bootstrap/macos.sh
```