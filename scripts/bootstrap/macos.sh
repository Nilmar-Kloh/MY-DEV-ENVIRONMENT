#!/usr/bin/env bash
# --------------------------------------------------
# scripts/bootstrap/macos.sh
#
# Purpose
#   Re-bootstrap (or fresh-bootstrap) the macOS development environment
#   from this repository. Idempotent. Re-running should not break things.
#
# Tier 2/3 automation per the project plan.
#
# Usage
#   bash scripts/bootstrap/macos.sh            # safe: brew bundle + symlinks
#   bash scripts/bootstrap/macos.sh --skip-brew # symlinks only (offline / CI)
#
# Side effects
#   - Installs/updates packages from the Brewfile.
#   - Creates ~/.zshrc, ~/.gitconfig, ~/.gitignore_global, ~/.tmux.conf
#     symlinks pointing into this repo.
#   - Does NOT touch SSH keys, Keychain, or app data.
# --------------------------------------------------

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SKIP_BREW=0
[[ "${1:-}" == "--skip-brew" ]] && SKIP_BREW=1

echo "==> MY-DEV-ENVIRONMENT macOS bootstrap"
echo "    repo: $REPO_ROOT"

# --------------------------------------------------
# Homebrew + Brewfile
# --------------------------------------------------
if [[ "$SKIP_BREW" -eq 0 ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "!! Homebrew not installed."
    echo "   Install from https://brew.sh and re-run, or pass --skip-brew."
    exit 1
  fi
  echo "==> brew bundle (Brewfile)"
  brew bundle --file="$REPO_ROOT/Brewfile"
fi

# --------------------------------------------------
# Dotfile symlinks
# By default, an existing non-symlink file at the destination is treated
# as a HARD STOP. Pass --force to back up and replace. This protects
# real user files from being silently overwritten.
# --------------------------------------------------
FORCE=0
for arg in "$@"; do
  [[ "$arg" == "--force" ]] && FORCE=1
done

symlink() {
  local src="$1"
  local dst="$2"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
      local backup="${dst}.backup-$(date -u +%Y%m%dT%H%M%SZ)"
      echo "!! $dst exists and is not a symlink. Backing up to $backup"
      mv "$dst" "$backup"
    else
      echo "!! SKIP: $dst exists and is not a symlink. Pass --force to overwrite."
      return 0
    fi
  fi
  ln -sf "$src" "$dst"
  echo "    linked $dst -> $src"
}

echo "==> dotfile symlinks"
symlink "$REPO_ROOT/configs/git/gitconfig"        "$HOME/.gitconfig"
symlink "$REPO_ROOT/configs/git/gitignore_global" "$HOME/.gitignore_global"
symlink "$REPO_ROOT/configs/tmux/tmux.conf"        "$HOME/.tmux.conf"

# Shell config: source-from-repo pattern (no symlink of .zshrc itself).
SHELL_RC="$HOME/.zshrc"
if [[ -e "$SHELL_RC" && ! "$SHELL_RC" -ef "$REPO_ROOT/configs/shell/zshrc" ]]; then
  if ! grep -q "MY-DEV-ENVIRONMENT" "$SHELL_RC"; then
    echo "==> appending MY-DEV-ENVIRONMENT source line to ~/.zshrc"
    cat >> "$SHELL_RC" <<'EOF'

# MY-DEV-ENVIRONMENT
export DEV_ENV_HOME="$HOME/Code/MY-DEV-ENVIRONMENT"
[[ -f "$DEV_ENV_HOME/configs/shell/zshrc" ]] && source "$DEV_ENV_HOME/configs/shell/zshrc"
EOF
  fi
fi

# Starship: the config file is referenced via $STARSHIP_CONFIG in zshrc.
mkdir -p "$HOME/.config"
symlink "$REPO_ROOT/configs/starship/starship.toml" "$HOME/.config/starship.toml"

# --------------------------------------------------
# VS Code (macOS path)
# --------------------------------------------------
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
symlink "$REPO_ROOT/configs/vscode/settings.json"   "$VSCODE_USER/settings.json"
symlink "$REPO_ROOT/configs/vscode/keybindings.json" "$VSCODE_USER/keybindings.json"

# --------------------------------------------------
# Validation
# --------------------------------------------------
echo "==> validating"
"$REPO_ROOT/scripts/inventory/validate.sh" --required-only || true

echo "==> done."