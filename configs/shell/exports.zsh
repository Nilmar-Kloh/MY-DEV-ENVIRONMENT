# --------------------------------------------------
# Editors
# --------------------------------------------------
export EDITOR="code --wait"
export VISUAL="$EDITOR"

# --------------------------------------------------
# Homebrew
# --------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# --------------------------------------------------
# Custom PATH
# --------------------------------------------------
export PATH="$HOME/.opencode/bin:$PATH"

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
