# --------------------------------------------------
# Editors
# --------------------------------------------------
export EDITOR="code --wait"
export VISUAL="$EDITOR"

# --------------------------------------------------
# Homebrew
# macOS (Apple Silicon and Intel). WSL2 / vanilla Linux: skip — install
# tools via the distro package manager or language-native installers.
# --------------------------------------------------
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
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
