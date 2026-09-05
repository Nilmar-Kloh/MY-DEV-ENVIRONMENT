#!/usr/bin/env bash
# --------------------------------------------------
# scripts/inventory/validate.sh
#
# Purpose
#   Verify that a set of expected tools exist on the current host and
#   report their versions. Designed to run on both macOS and Linux
#   (including WSL). Does NOT modify the system.
#
# Tier 4 automation per the project plan.
#
# Usage
#   bash scripts/inventory/validate.sh
#   bash scripts/inventory/validate.sh --required-only
#
# Exit codes
#   0 = all required tools found
#   1 = one or more required tools missing
# --------------------------------------------------

set -uo pipefail

REQUIRED=(
  "git:git --version"
  "python3:python3 --version"
  "uv:uv --version"
  "go:go version"
  "docker:docker --version"
)

OPTIONAL=(
  "node:node --version"
  "npm:npm --version"
  "pnpm:pnpm --version"
  "terraform:terraform --version"
  "tofu:tofu --version"
  "kubectl:kubectl version --client=true"
  "helm:helm version --short"
  "k9s:k9s version"
  "aws:aws --version"
  "gcloud:gcloud --version"
  "az:az --version"
  "psql:psql --version"
  "redis-cli:redis-cli --version"
  "fzf:fzf --version"
  "ripgrep:rg --version"
  "fd:fd --version"
  "bat:bat --version"
  "eza:eza --version"
  "jq:jq --version"
  "tmux:tmux -V"
  "starship:starship --version"
  "ruff:ruff --version"
  "uvicorn:uvicorn --version"
  "mkcert:mkcert --version"
  "gh:gh --version"
  "ssh:ssh -V"
)

REQUIRED_ONLY=0
if [[ "${1:-}" == "--required-only" ]]; then
  REQUIRED_ONLY=1
fi

ok=0
miss=0

check_tool() {
  local name="$1"
  local cmd="$2"
  local required="$3"

  if command -v "${cmd%% *}" >/dev/null 2>&1; then
    version="$(eval "$cmd" 2>/dev/null | head -n1 | tr -d '\n' | cut -c1-60)"
    line=$(printf 'OK      %-12s %s' "$name" "$version")
    printf '%s\n' "$line"
    ok=$((ok+1))
  else
    if [[ "$required" == "1" ]]; then
      line=$(printf 'MISSING %-12s (REQUIRED)' "$name")
      printf '%s\n' "$line"
      miss=$((miss+1))
    else
      line=$(printf 'missing %-12s (optional)' "$name")
      printf '%s\n' "$line"
    fi
  fi
}

printf '%s\n' 'Tool           Status      Version'
printf '%s\n' '----           ------      -------'

for pair in "${REQUIRED[@]}"; do
  check_tool "${pair%%:*}" "${pair#*:}" 1
done

if [[ "$REQUIRED_ONLY" -eq 0 ]]; then
  for pair in "${OPTIONAL[@]}"; do
    check_tool "${pair%%:*}" "${pair#*:}" 0
  done
fi

printf '\nSummary: %d OK, %d missing required\n' "$ok" "$miss"

if [[ "$miss" -gt 0 ]]; then
  exit 1
fi
exit 0