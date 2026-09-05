# Windows host aliases
#
# Conceptually mirrors configs/shell/aliases.zsh.
# Anything that needs GNU coreutils (ls, cat, etc.) belongs in WSL2 aliases
# (see configs/shell/aliases.zsh), not here.
#
# Note: PowerShell Set-Alias only takes a command name, never arguments.
# Anything that requires arguments (e.g., `git status`) MUST be a function.

# Git shortcuts — these are functions because `git status`, `git commit`
# etc. take arguments.
function gs { git status @args }
function ga { git add    @args }
function gc { git commit @args }
function gp { git push   @args }
function gl { git pull   @args }

# py launcher on Windows (installs of python.org include `py`).
if (Get-Command py -ErrorAction SilentlyContinue) {
    Set-Alias -Name python -Value py
}

# Modern replacements for built-ins, where present. These are
# single-name aliases and DO work with Set-Alias.
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Set-Alias -Name cat -Value bat
}
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    Set-Alias -Name fz -Value fzf
}

# Convenience helpers
function mkcd   { param([string]$Path) New-Item -ItemType Directory -Force -Path $Path | Out-Null; Set-Location $Path }
function wslhome { wsl ~ }
function wslinto { wsl --cd (Get-Location).Path }