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
#   bash scripts/bootstrap/macos.sh                # default safe mode
#   bash scripts/bootstrap/macos.sh --skip-brew    # symlinks only
#   bash scripts/bootstrap/macos.sh --dry-run       # preview, no changes
#   bash scripts/bootstrap/macos.sh --force         # back up + overwrite
#                                                 # existing real files
#
# Side effects
#   - Installs/updates packages from the Brewfile (unless --skip-brew).
#   - Creates symlinks for ~/.gitconfig, ~/.gitignore_global,
#     ~/.tmux.conf, ~/.config/starship.toml,
#     ~/Library/Application Support/Code/User/{settings,keybindings}.json.
#   - Does NOT touch SSH keys, Keychain, or app data.
#   - Does NOT modify ~/.zshrc. The user is expected to symlink it
#     manually if desired (see configs/shell/zshrc).
#
# Safety
#   By default, an existing non-symlink file at the destination causes
#   that link to be SKIPPED. Use --force to back up the existing file
#   to <dst>.backup-<UTC timestamp> and replace it. Use --dry-run to
#   see what would happen without making any changes.
# --------------------------------------------------

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

SKIP_BREW=0
FORCE=0
DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --skip-brew) SKIP_BREW=1 ;;
    --force)     FORCE=1 ;;
    --dry-run)   DRY_RUN=1 ;;
    --help|-h)
      sed -n '2,30p' "$0"
      exit 0
      ;;
    *)
      echo "!! Unknown argument: $arg" >&2
      echo "   Use --help to see valid options." >&2
      exit 2
      ;;
  esac
done

echo "==> MY-DEV-ENVIRONMENT macOS bootstrap"
echo "    repo: $REPO_ROOT"
[[ "$DRY_RUN" -eq 1 ]] && echo "    MODE: dry-run (no changes)"
[[ "$FORCE"   -eq 1 ]] && echo "    MODE: force (existing files backed up + replaced)"

run() {
  # Echo a command and optionally execute it.
  local desc="$1"; shift
  echo "    $*  ($desc)"
  [[ "$DRY_RUN" -eq 0 ]] && eval "$@"
}

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
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "    would run: brew bundle --file=\"$REPO_ROOT/Brewfile\""
  else
    brew bundle --file="$REPO_ROOT/Brewfile"
  fi
else
  echo "==> skipping Homebrew (--skip-brew)"
fi

# --------------------------------------------------
# Dotfile symlinks
#
# Default behavior:
#   - existing symlink pointing elsewhere → replace
#   - existing real file → SKIP unless --force (in which case: back up + replace)
#   - missing → create
# --------------------------------------------------
symlink() {
  local src="$1"
  local dst="$2"
  if [[ -L "$dst" ]]; then
    run "replace existing symlink" "ln -sf \"$src\" \"$dst\""
    return
  fi
  if [[ -e "$dst" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
      local backup="${dst}.backup-$(date -u +%Y%m%dT%H%M%SZ)"
      run "back up to $backup and link" "mv \"$dst\" \"$backup\" && ln -sf \"$src\" \"$dst\""
    else
      echo "    SKIP: $dst exists and is not a symlink. Pass --force to overwrite."
    fi
    return
  fi
  run "create" "ln -sf \"$src\" \"$dst\""
}

echo "==> dotfile symlinks"
symlink "$REPO_ROOT/configs/git/gitconfig"        "$HOME/.gitconfig"
symlink "$REPO_ROOT/configs/git/gitignore_global" "$HOME/.gitignore_global"
symlink "$REPO_ROOT/configs/git/gitconfig.macos"  "$HOME/.gitconfig.local"
symlink "$REPO_ROOT/configs/tmux/tmux.conf"        "$HOME/.tmux.conf"

mkdir -p "$HOME/.config"
symlink "$REPO_ROOT/configs/starship/starship.toml" "$HOME/.config/starship.toml"

# --------------------------------------------------
# ~/.zshrc
#
# This script does NOT modify ~/.zshrc. Two acceptable patterns:
#   (a) Symlink it to the repo's zshrc:
#         ln -sf "$REPO_ROOT/configs/shell/zshrc" ~/.zshrc
#   (b) Source-from-repo by appending the include line:
#         echo 'source "$HOME/Code/MY-DEV-ENVIRONMENT/configs/shell/zshrc"' >> ~/.zshrc
# The repo's own zshrc already handles aliases/exports/functions/starship.
# --------------------------------------------------
echo "==> ~/.zshrc: no change. See header comment in scripts/bootstrap/macos.sh."

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
if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "==> skipping validation in dry-run mode."
else
  echo "==> validating"
  "$REPO_ROOT/scripts/inventory/validate.sh" --profile mac || true
fi

echo "==> done."