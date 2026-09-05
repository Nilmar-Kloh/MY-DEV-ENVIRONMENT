
# --------------------------------------------------
# Navigation
# --------------------------------------------------
alias ..="cd .."
alias ...="cd ../.."

# --------------------------------------------------
# File Listing
# Falls back to standard ls if eza is not installed.
# --------------------------------------------------
if command -v eza >/dev/null 2>&1; then
    alias ls="eza"
    alias ll="eza -lah"
    alias la="eza -a"
    alias lt="eza --tree"
fi

# --------------------------------------------------
# File Viewing
# --------------------------------------------------
if command -v bat >/dev/null 2>&1; then
    alias cat="bat"
fi

# --------------------------------------------------
# Git
# --------------------------------------------------
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"

# --------------------------------------------------
# Python
# `py` alias for python3 on macOS/Linux.
# On Windows PowerShell, the equivalent is `py -3` (see configs/windows/powershell/aliases.ps1).
# --------------------------------------------------
alias py="python3"
