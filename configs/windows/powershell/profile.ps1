# MY-DEV-ENVIRONMENT — Windows host PowerShell profile
#
# Installed to $PROFILE on the Windows host. See ./README.md.
# Sources the aliases file from this repo. The WSL-side shell has its own
# configuration under configs/shell/.

$ErrorActionPreference = 'Stop'

# Resolve the repo root. Adjust if you clone to a different location.
$RepoRoot = Join-Path $env:USERPROFILE 'src\MY-DEV-ENVIRONMENT'
if (-not (Test-Path $RepoRoot)) {
    Write-Warning "MY-DEV-ENVIRONMENT repo not found at $RepoRoot"
    return
}

$AliasesFile = Join-Path $RepoRoot 'configs\windows\powershell\aliases.ps1'
if (Test-Path $AliasesFile) {
    . $AliasesFile
}

# Editor
$env:EDITOR = 'code --wait'
$env:VISUAL = $env:EDITOR

# Ensure git is on PATH (winget Git installs here for x64)
$gitBin = 'C:\Program Files\Git\bin'
if ((Test-Path $gitBin) -and ($env:PATH -notlike "*$gitBin*")) {
    $env:PATH = "$gitBin;$env:PATH"
}

# Starship prompt (Windows-side). If you only use WSL2, you can skip this.
if (Get-Command starship -ErrorAction SilentlyContinue) {
    $env:STARSHIP_CONFIG = Join-Path $RepoRoot 'configs\starship\starship.toml'
    Invoke-Expression (& starship init powershell)
}