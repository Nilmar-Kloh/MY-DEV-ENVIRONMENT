#!/usr/bin/env bash
# --------------------------------------------------
# scripts/inventory/validate.sh
#
# Purpose
#   Verify that a profile-defined set of expected tools exist on the
#   current host and report their versions. Designed to run on macOS,
#   Linux, and inside WSL2. Does NOT modify the system.
#
# Profiles
#   --profile mac             macOS host (the outgoing machine)
#   --profile wsl            WSL2 distro (the primary Linux dev env)
#   --profile windows-host   Windows host PowerShell / Git Bash
#   --profile universal      tools expected on every supported host
#   (no flag)                universal — the safe default
#
# Tiering source: docs/migration/manifest.md. Only manifest Required=yes
# tools are REQUIRED here; everything else is OPTIONAL. In particular,
# terraform/kubectl/helm/k9s/cloud CLIs are deliberately OPTIONAL —
# useful, but their absence must not fail a bootstrap.
#
# Each profile has a REQUIRED list (missing = failure) and an OPTIONAL
# list (informational).
#
# Usage
#   bash scripts/inventory/validate.sh
#   bash scripts/inventory/validate.sh --profile wsl
#   bash scripts/inventory/validate.sh --profile mac --required-only
#
# Exit codes
#   0 = all required tools found for the selected profile
#   1 = one or more required tools missing
#   2 = invalid arguments
# --------------------------------------------------

set -uo pipefail

PROFILE="universal"
REQUIRED_ONLY=0

# Two-pass argument handling so `--profile mac` (space form) works.
ARGS=("$@")
i=0
while [[ $i -lt $# ]]; do
  arg="${ARGS[$i]}"
  case "$arg" in
    --profile=*) PROFILE="${arg#--profile=}" ;;
    --profile)
      i=$((i+1))
      PROFILE="${ARGS[$i]:-universal}"
      ;;
    --required-only) REQUIRED_ONLY=1 ;;
    --help|-h)
      sed -n '2,40p' "$0"
      exit 0
      ;;
    *)
      echo "!! Unknown argument: $arg" >&2
      exit 2
      ;;
  esac
  i=$((i+1))
done

# --------------------------------------------------
# Profiles
# --------------------------------------------------
# Format: "name|command"
universal_required=(
  "git|git --version"
)
universal_optional=(
  "gh|gh --version"
  "fzf|fzf --version"
  "jq|jq --version"
  "ripgrep|rg --version"
)

mac_required=(
  "git|git --version"
  "python3|python3 --version"
  "uv|uv --version"
  "go|go version"
  "docker|docker --version"
)
mac_optional=(
  "node|node --version"
  "npm|npm --version"
  "pnpm|pnpm --version"
  "bat|bat --version"
  "eza|eza --version"
  "fd|fd --version"
  "tmux|tmux -V"
  "starship|starship --version"
  "mkcert|mkcert --version"
  "ffmpeg|ffmpeg -version"
  "opencode|opencode --version"
  "gh|gh --version"
  "git-filter-repo|git-filter-repo --version"
)

wsl_required=(
  "git|git --version"
  "ssh|ssh -V"
  "uv|uv --version"
  "go|go version"
  "docker|docker --version"
)
wsl_optional=(
  "node|node --version"
  "npm|npm --version"
  "pnpm|pnpm --version"
  "terraform|terraform --version"
  "tofu|tofu --version"
  "kubectl|kubectl version --client=true"
  "helm|helm version --short"
  "k9s|k9s version"
  "psql|psql --version"
  "redis-cli|redis-cli --version"
  "fzf|fzf --version"
  "ripgrep|rg --version"
  "fd|fd --version"
  "bat|bat --version"
  "eza|eza --version"
  "jq|jq --version"
  "tmux|tmux -V"
  "starship|starship --version"
  "ruff|ruff --version"
  "uvicorn|uvicorn --version"
  "mkcert|mkcert --version"
  "gh|gh --version"
)

windows_host_required=(
  "git|git --version"
  "code|code --version"
)
windows_host_optional=(
  "node|node --version"
  "npm|npm --version"
  "pwsh|pwsh --version"
  "az|az --version"
  "aws|aws --version"
  "gcloud|gcloud --version"
)

case "$PROFILE" in
  universal)     REQUIRED=("${universal_required[@]}");     OPTIONAL=("${universal_optional[@]}") ;;
  mac)           REQUIRED=("${mac_required[@]}");           OPTIONAL=("${mac_optional[@]}") ;;
  wsl)           REQUIRED=("${wsl_required[@]}");           OPTIONAL=("${wsl_optional[@]}") ;;
  windows-host)  REQUIRED=("${windows_host_required[@]}"); OPTIONAL=("${windows_host_optional[@]}") ;;
  *)
    echo "!! Unknown profile: $PROFILE" >&2
    echo "   Valid: universal, mac, wsl, windows-host" >&2
    exit 2
    ;;
esac

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
      line=$(printf 'MISSING %-12s (REQUIRED for %s)' "$name" "$PROFILE")
      printf '%s\n' "$line"
      miss=$((miss+1))
    else
      line=$(printf 'missing %-12s (optional)' "$name")
      printf '%s\n' "$line"
    fi
  fi
}

printf '%s\n' "Profile:        $PROFILE"
printf '%s\n' "Required:       ${#REQUIRED[@]} tool(s)"
printf '%s\n' "Optional:       ${#OPTIONAL[@]} tool(s)"
printf '%s\n' 'Tool           Status      Version'
printf '%s\n' '----           ------      -------'

for pair in "${REQUIRED[@]}"; do
  check_tool "${pair%%|*}" "${pair#*|}" 1
done

if [[ "$REQUIRED_ONLY" -eq 0 ]]; then
  for pair in "${OPTIONAL[@]}"; do
    check_tool "${pair%%|*}" "${pair#*|}" 0
  done
fi

printf '\nSummary: %d OK, %d missing required\n' "$ok" "$miss"

if [[ "$miss" -gt 0 ]]; then
  exit 1
fi
exit 0