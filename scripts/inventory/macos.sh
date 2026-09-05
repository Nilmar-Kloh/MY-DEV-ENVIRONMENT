#!/usr/bin/env bash
# --------------------------------------------------
# scripts/inventory/macos.sh
#
# Purpose
#   Inspect the current macOS workstation and emit a sanitized
#   inventory suitable for review and migration planning.
#
# This script is READ-ONLY. It does not modify the system.
#
# Output
#   Writes timestamped Markdown files to inventory/raw/.
#   Also prints a short summary to stdout.
#
# Usage
#   bash scripts/inventory/macos.sh
#   bash scripts/inventory/macos.sh --verbose
#
# Safety
#   Never prints secret values. Outputs variable NAMES, never contents.
# --------------------------------------------------

set -u

# Note: not using `set -e` because a missing or broken tool should not
# terminate the inventory. We DO use `set -u` to catch typos.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RAW_DIR="$REPO_ROOT/inventory/raw"
TS="$(date -u +%Y%m%dT%H%M%SZ)"
VERBOSE="${1:-}"

mkdir -p "$RAW_DIR"

# --------------------------------------------------
# Helpers
# --------------------------------------------------
section() {
  printf '\n=== %s ===\n' "$1"
}

have() {
  command -v "$1" >/dev/null 2>&1
}

# Collect environment-variable NAMES only. Values are NEVER printed.
# The body uses a group + pipeline. To allow the function to be called
# by name later, the entire pipeline (group | while | sort) is the
# function body — bash supports function bodies that are pipelines.
env_names() {
  {
    env -0 2>/dev/null
    printf '\0'
  } | while IFS= read -r -d '' entry; do
      [[ -z "$entry" ]] && continue
      name="${entry%%=*}"
      printf '%s\n' "$name"
    done | sort -u
}

# --------------------------------------------------
# macOS version + hardware context
# --------------------------------------------------
section "machine"
{
  echo "# Machine"
  echo
  echo "- Date (UTC): $TS"
  echo "- Hostname: $(hostname)"
  echo "- macOS version: $(sw_vers -productVersion 2>/dev/null || echo unknown)"
  echo "- macOS build: $(sw_vers -buildVersion 2>/dev/null || echo unknown)"
  echo "- Hardware model: $(sysctl -n hw.model 2>/dev/null || echo unknown)"
  echo "- Chip: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo unknown)"
  echo "- Architecture: $(uname -m)"
  echo "- Shell: ${SHELL:-unknown}"
  echo "- Logged-in user: $(whoami)"
} > "$RAW_DIR/machine.md"

# --------------------------------------------------
# Homebrew
# --------------------------------------------------
section "homebrew"
if have brew; then
  brew --version | head -n1 | tee "$RAW_DIR/homebrew-version.txt"
  echo
  echo "-- formulae (leaves only) --"
  brew leaves > "$RAW_DIR/homebrew-formulae.txt" || true
  cat "$RAW_DIR/homebrew-formulae.txt"
  echo
  echo "-- casks --"
  brew list --cask 2>/dev/null > "$RAW_DIR/homebrew-casks.txt" || true
  cat "$RAW_DIR/homebrew-casks.txt"
  echo
  echo "-- taps --"
  brew tap > "$RAW_DIR/homebrew-taps.txt" || true
  cat "$RAW_DIR/homebrew-taps.txt"
else
  echo "Homebrew not installed."
  echo "Homebrew not installed." > "$RAW_DIR/homebrew-version.txt"
fi

# --------------------------------------------------
# /Applications inventory (only display names; not data)
# --------------------------------------------------
section "applications"
{
  echo "# /Applications (display names only)"
  echo
  if [[ -d /Applications ]]; then
    # List .app bundle names; no path traversal beyond /Applications.
    find /Applications -maxdepth 2 -name "*.app" -type d 2>/dev/null \
      | sed 's|.*/||; s|\.app$||' \
      | sort -u
  fi
  echo
  echo "# /Applications/Utilities (display names only)"
  if [[ -d /Applications/Utilities ]]; then
    find /Applications/Utilities -maxdepth 2 -name "*.app" -type d 2>/dev/null \
      | sed 's|.*/||; s|\.app$||' \
      | sort -u
  fi
} > "$RAW_DIR/applications.txt"

wc -l < "$RAW_DIR/applications.txt" | xargs printf '%s application entries\n'

# --------------------------------------------------
# CLI tools — targeted, not a full PATH dump
# Each entry is "tool|version-command". The version command is best-effort;
# a non-zero exit is acceptable and produces a blank version.
# --------------------------------------------------
section "cli-tools"
TARGET_TOOLS=(
  "git|git --version"
  "gh|gh --version"
  "go|go version"
  "node|node --version"
  "npm|npm --version"
  "pnpm|pnpm --version"
  "yarn|yarn --version"
  "python|python3 --version"
  "python3|python3 --version"
  "pip|pip3 --version"
  "pipx|pipx --version"
  "uv|uv --version"
  "pyenv|pyenv --version"
  "ruff|ruff --version"
  "mypy|mypy --version"
  "pytest|pytest --version"
  "black|black --version"
  "isort|isort --version"
  "uvicorn|uvicorn --version"
  "docker|docker --version"
  "docker-compose|docker compose version"
  "colima|colima --version"
  "podman|podman --version"
  "kubectl|kubectl version --client"
  "helm|helm version"
  "k9s|k9s version"
  "terraform|terraform --version"
  "tofu|tofu --version"
  "ansible|ansible --version"
  "packer|packer --version"
  "aws|aws --version"
  "gcloud|gcloud --version"
  "az|az --version"
  "psql|psql --version"
  "redis-cli|redis-cli --version"
  "sqlite3|sqlite3 --version"
  "mongosh|mongosh --version"
  "ffmpeg|ffmpeg -version"
  "jq|jq --version"
  "yq|yq --version"
  "bat|bat --version"
  "eza|eza --version"
  "fd|fd --version"
  "ripgrep|rg --version"
  "fzf|fzf --version"
  "zoxide|zoxide --version"
  "starship|starship --version"
  "tmux|tmux -V"
  "mkcert|mkcert --version"
  "ngrok|ngrok --version"
  "brew|brew --version"
  "mas|mas --version"
  "code|code --version"
  "cursor|cursor --version"
  "code-insiders|code-insiders --version"
  "ssh|ssh -V"
  "ssh-add|ssh-add -V"
  "scp|scp -V"
  "make|make --version"
  "cmake|cmake --version"
  "gcc|gcc --version"
  "clang|clang --version"
  "java|java -version"
  "javac|javac -version"
  "mvn|mvn --version"
  "gradle|gradle --version"
  "ruby|ruby --version"
  "gem|gem --version"
  "bundler|bundle --version"
  "cargo|cargo --version"
  "rustc|rustc --version"
  "rustup|rustup --version"
)

{
  echo "# CLI tools"
  echo
  printf '%-22s %-12s %s\n' TOOL FOUND VERSION
  printf '%-22s %-12s %s\n' ---- ----- -------
  for entry in "${TARGET_TOOLS[@]}"; do
    t="${entry%%|*}"
    cmd="${entry#*|}"
    if have "$t"; then
      v="$(eval "$cmd" 2>/dev/null | head -n1 | tr -d '\n' | cut -c1-60 || true)"
      printf '%-22s %-12s %s\n' "$t" yes "$v"
    else
      printf '%-22s %-12s %s\n' "$t" "no" ""
    fi
  done
} | tee "$RAW_DIR/cli-tools.txt"

# --------------------------------------------------
# Language runtime versions (explicit, intentional capture)
# --------------------------------------------------
section "languages"
{
  echo "# Languages"
  echo
  for pair in \
      "python|python3 --version" \
      "python|python --version" \
      "go|go version" \
      "node|node --version" \
      "npm|npm --version" \
      "pnpm|pnpm --version" \
      "yarn|yarn --version" \
      "ruby|ruby --version" \
      "java|java -version" \
      "rust|rustc --version" \
      "cargo|cargo --version" \
      "dotnet|dotnet --version"
  do
    name="${pair%%|*}"
    cmd="${pair#*|}"
    bin="${cmd%% *}"
    if have "$bin"; then
      out="$(eval "$cmd" 2>/dev/null | head -n1 || true)"
      echo "- **$name**: $out"
    fi
  done
} | tee "$RAW_DIR/languages.txt"

# --------------------------------------------------
# Git configuration (structural summary — values redacted for keys
# that may carry personal/identity data; the repo's own gitconfig is
# the source of truth for the safe subset).
# --------------------------------------------------
section "git"
if have git; then
  redacted_value() {
    # Print <REDACTED> if the config key has a value, empty otherwise.
    local v
    v="$(git config --global "$1" 2>/dev/null || true)"
    [[ -n "$v" ]] && printf '%s' "<REDACTED>"
  }
  {
    echo "# Git (structural summary)"
    echo
    echo "## Identity (values redacted)"
    echo "- user.name: $(redacted_value user.name)"
    echo "- user.email: $(redacted_value user.email)"
    echo "- user.signingkey: $(redacted_value user.signingkey)"
    echo
    echo "## Behavior"
    echo "- init.defaultBranch: $(redacted_value init.defaultBranch)"
    echo "- pull.rebase: $(redacted_value pull.rebase)"
    echo "- push.autoSetupRemote: $(redacted_value push.autoSetupRemote)"
    echo "- fetch.prune: $(redacted_value fetch.prune)"
    echo "- core.autocrlf: $(redacted_value core.autocrlf)"
    echo "- core.editor: $(redacted_value core.editor)"
    echo "- core.excludesfile: $(redacted_value core.excludesfile)"
    echo "- rerere.enabled: $(redacted_value rerere.enabled)"
    echo "- rebase.autosquash: $(redacted_value rebase.autosquash)"
    echo "- color.ui: $(redacted_value color.ui)"
    echo "- credential.helper: $(redacted_value credential.helper)"
    echo "- gpg.format: $(redacted_value gpg.format)"
    echo
    echo "## Aliases (count only)"
    alias_count="$(git config --global --get-regexp '^alias\.' 2>/dev/null | wc -l | tr -d '[:space:]')"
    echo "- aliases defined: $alias_count"
    echo
    echo "## Version"
    git --version
  } > "$RAW_DIR/git.md"
  cat "$RAW_DIR/git.md"
else
  echo "git not installed."
fi

# --------------------------------------------------
# SSH (structural summary ONLY — hostnames, IPs, key fingerprints,
# usernames, filenames that imply key types, and SSH config contents
# are NEVER written anywhere, even to inventory/raw/. This is the
# strictest setting on purpose. See ~/.ssh/ on the source machine for
# full detail.
# --------------------------------------------------
section "ssh"
if [[ -d "$HOME/.ssh" ]]; then
  ssh_present=yes
  ssh_file_count=$(find "$HOME/.ssh" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d '[:space:]')
  ssh_key_count=$(find "$HOME/.ssh" -maxdepth 1 -type f \
      ! -name '*.pub' \
      ! -name 'known_hosts*' \
      ! -name 'config' \
      ! -name 'environment' \
      ! -name 'rc' \
      2>/dev/null | wc -l | tr -d '[:space:]')
  ssh_pub_count=$(find "$HOME/.ssh" -maxdepth 1 -type f -name '*.pub' 2>/dev/null | wc -l | tr -d '[:space:]')
  if [[ -f "$HOME/.ssh/config" ]]; then has_config=yes; else has_config=no; fi
  if [[ -f "$HOME/.ssh/known_hosts" ]]; then has_known_hosts=yes; else has_known_hosts=no; fi
else
  ssh_present=no
  ssh_file_count=0
  ssh_key_count=0
  ssh_pub_count=0
  has_config=no
  has_known_hosts=no
fi

{
  echo "# SSH (structural summary)"
  echo
  echo "- ~/.ssh/ exists: $ssh_present"
  echo "- non-key files in ~/.ssh/: $ssh_file_count"
  echo "- private keys present: $ssh_key_count"
  echo "- public keys present: $ssh_pub_count"
  echo "- ssh config file: $has_config"
  echo "- known_hosts file: $has_known_hosts"
  echo
  echo "(No hostnames, IPs, fingerprints, file sizes, or usernames are"
  echo "captured. See ~/.ssh/ on the source machine for full detail.)"
} > "$RAW_DIR/ssh.md"
cat "$RAW_DIR/ssh.md"

# --------------------------------------------------
# Shell configuration references (paths only)
# --------------------------------------------------
section "shell"
{
  echo "# Shell configuration (paths only — contents NOT dumped)"
  echo
  for f in .zshrc .zprofile .zshenv .bashrc .bash_profile .profile \
           .aliases .functions .exports .path; do
    if [[ -f "$HOME/$f" ]]; then
      bytes="$(wc -c < "$HOME/$f" | tr -d '[:space:]')"
      echo "- ~/$f (exists, ${bytes} bytes)"
    fi
  done
  for f in .zshrc .tmux.conf .gitconfig .config/starship.toml; do
    if [[ -L "$HOME/$f" ]]; then
      target="$(readlink "$HOME/$f")"
      echo "- ~/$f is a symlink -> $target"
    fi
  done
} | tee "$RAW_DIR/shell-files.txt"

# --------------------------------------------------
# Environment variable NAMES only
# --------------------------------------------------
section "env-variable-names"
env_names > "$RAW_DIR/env-variable-names.txt"
echo "Captured $(wc -l < "$RAW_DIR/env-variable-names.txt") variable names."
if [[ "$VERBOSE" == "--verbose" ]]; then
  echo "(names only — see $RAW_DIR/env-variable-names.txt)"
fi

# --------------------------------------------------
# Containers
# --------------------------------------------------
section "containers"
{
  echo "# Container runtimes"
  echo
  for t in docker colima podman nerdctl lima; do
    if have "$t"; then
      v="$("$t" --version 2>/dev/null | head -n1)"
      echo "- $t: $v"
    fi
  done
  echo
  echo "# Docker context (no auth)"
  if have docker; then
    docker context ls 2>/dev/null | sed 's/^/- /' || true
  fi
} | tee "$RAW_DIR/containers.txt"

# --------------------------------------------------
# Summary
# --------------------------------------------------
section "summary"
echo "Raw inventory written to: $RAW_DIR"
ls -la "$RAW_DIR"