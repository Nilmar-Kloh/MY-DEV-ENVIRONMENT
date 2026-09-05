# Manifests — Windows

The Windows manifest is **`platforms/windows/packages.txt`** (generated
by `winget export` and curated). It is referenced from
`scripts/bootstrap/windows.ps1`.

To generate one (run on the Windows machine):

```powershell
winget export -o platforms\windows\packages.txt
```

Review the output — winget may include items you do not actually want
reinstalled. Commit the curated version.

To install from it:

```powershell
winget import -i platforms\windows\packages.txt --ignore-versions
```