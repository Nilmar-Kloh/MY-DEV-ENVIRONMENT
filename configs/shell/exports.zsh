# --------------------------------------------------
# Editors
# --------------------------------------------------
export EDITOR="code --wait"
export VISUAL="$EDITOR"

# --------------------------------------------------
# Homebrew
# macOS (Apple Silicon) and Linuxbrew paths.
# WSL2 / vanilla Linux: this block is skipped.
# --------------------------------------------------
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --------------------------------------------------
# Custom PATH
# --------------------------------------------------
export PATH="$HOME/.opencode/bin:$HOME/go/bin:$PATH"

# --------------------------------------------------
# History
# --------------------------------------------------
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
