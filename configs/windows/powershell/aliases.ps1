# Windows host aliases
#
# Conceptually mirrors configs/shell/aliases.zsh.
# Anything that needs GNU coreutils (ls, cat, etc.) belongs in WSL2 aliases
# (see configs/shell/aliases.zsh), not here.

Set-Alias -Name gs -Value git -ArgumentList 'status' -Option AllScope
Set-Alias -Name ga -Value git -ArgumentList 'add'    -Option AllScope
Set-Alias -Name gc -Value git -ArgumentList 'commit' -Option AllScope
Set-Alias -Name gp -Value git -ArgumentList 'push'   -Option AllScope
Set-Alias -Name gl -Value git -ArgumentList 'pull'   -Option AllScope

# py launcher on Windows (installs of python.org include `py`).
if (Get-Command py -ErrorAction SilentlyContinue) {
    Set-Alias -Name python -Value py
}

# Modern replacements for built-ins, where present.
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Set-Alias -Name cat -Value bat
}
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    Set-Alias -Name fz -Value fzf
}

# Convenience helpers
function mkcd { param([string]$Path) New-Item -ItemType Directory -Force -Path $Path | Out-Null; Set-Location $Path }

# WSL shortcut
function wslhome { wsl ~ }
function wslinto { wsl --cd (Get-Location).Path }