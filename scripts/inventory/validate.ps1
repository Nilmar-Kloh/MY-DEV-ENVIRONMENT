#!/usr/bin/env pwsh
# --------------------------------------------------
# scripts/inventory/validate.ps1
#
# Purpose
#   Windows-host equivalent of scripts/inventory/validate.sh.
#   Profile-aware. Reads the same tool lists but reports in
#   PowerShell-native format.
#
# Usage
#   pwsh scripts/inventory/validate.ps1
#   pwsh scripts/inventory/validate.ps1 -Profile wsl
#   pwsh scripts/inventory/validate.ps1 -Profile windows-host
#
# Profiles
#   universal      tools expected everywhere
#   mac            macOS host
#   wsl            WSL2 distro
#   windows-host   Windows host
# --------------------------------------------------

[CmdletBinding()]
param(
    [ValidateSet('universal', 'mac', 'wsl', 'windows-host')]
    [string]$Profile = 'universal',
    [switch]$RequiredOnly
)

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot  = Resolve-Path "$ScriptDir/../.."

# --------------------------------------------------
# Profile definitions (mirroring validate.sh)
# --------------------------------------------------
$Profiles = @{
    'universal' = @{
        Required = @(@{n='git'; c='git --version'})
        Optional = @(@{n='gh'; c='gh --version'},
                     @{n='fzf'; c='fzf --version'},
                     @{n='jq'; c='jq --version'},
                     @{n='ripgrep'; c='rg --version'})
    }
    'mac' = @{
        Required = @(@{n='git'; c='git --version'},
                     @{n='python3'; c='python3 --version'},
                     @{n='uv'; c='uv --version'},
                     @{n='go'; c='go version'},
                     @{n='docker'; c='docker --version'})
        Optional = @(@{n='node'; c='node --version'},
                     @{n='npm'; c='npm --version'},
                     @{n='pnpm'; c='pnpm --version'},
                     @{n='bat'; c='bat --version'},
                     @{n='eza'; c='eza --version'},
                     @{n='fd'; c='fd --version'},
                     @{n='tmux'; c='tmux -V'},
                     @{n='starship'; c='starship --version'},
                     @{n='mkcert'; c='mkcert --version'},
                     @{n='ffmpeg'; c='ffmpeg -version'},
                     @{n='opencode'; c='opencode --version'},
                     @{n='gh'; c='gh --version'},
                     @{n='git-filter-repo'; c='git-filter-repo --version'})
    }
    'wsl' = @{
        Required = @(@{n='git'; c='git --version'},
                     @{n='ssh'; c='ssh -V'},
                     @{n='uv'; c='uv --version'},
                     @{n='go'; c='go version'},
                     @{n='docker'; c='docker --version'})
        Optional = @(@{n='node'; c='node --version'},
                     @{n='npm'; c='npm --version'},
                     @{n='pnpm'; c='pnpm --version'},
                     @{n='terraform'; c='terraform --version'},
                     @{n='tofu'; c='tofu --version'},
                     @{n='kubectl'; c='kubectl version --client=true'},
                     @{n='helm'; c='helm version --short'},
                     @{n='k9s'; c='k9s version'},
                     @{n='psql'; c='psql --version'},
                     @{n='redis-cli'; c='redis-cli --version'},
                     @{n='fzf'; c='fzf --version'},
                     @{n='ripgrep'; c='rg --version'},
                     @{n='fd'; c='fd --version'},
                     @{n='bat'; c='bat --version'},
                     @{n='eza'; c='eza --version'},
                     @{n='jq'; c='jq --version'},
                     @{n='tmux'; c='tmux -V'},
                     @{n='starship'; c='starship --version'},
                     @{n='ruff'; c='ruff --version'},
                     @{n='uvicorn'; c='uvicorn --version'},
                     @{n='mkcert'; c='mkcert --version'},
                     @{n='gh'; c='gh --version'})
    }
    'windows-host' = @{
        Required = @(@{n='git'; c='git --version'},
                     @{n='code'; c='code --version'})
        Optional = @(@{n='node'; c='node --version'},
                     @{n='npm'; c='npm --version'},
                     @{n='pwsh'; c='pwsh --version'},
                     @{n='az'; c='az --version'},
                     @{n='aws'; c='aws --version'},
                     @{n='gcloud'; c='gcloud --version'})
    }
}

if (-not $Profiles.ContainsKey($Profile)) {
    Write-Error "Unknown profile: $Profile. Valid: $($Profiles.Keys -join ', ')"
    exit 2
}

$def = $Profiles[$Profile]

function Test-Tool {
    param($Tool, [bool]$Required)
    $bin = ($Tool.c -split ' ')[0]
    $found = Get-Command $bin -ErrorAction SilentlyContinue
    if ($found) {
        try {
            $args = $Tool.c -split ' ' | Select-Object -Skip 1
            $v = (& $bin $args 2>&1 | Select-Object -First 1) -replace "`n"," "
            if (-not $v) { $v = '(no output)' }
        } catch {
            $v = "(error: $($_.Exception.Message))"
        }
        $status = 'OK'
        $script:ok++
    } else {
        if ($Required) {
            $status = 'MISSING'
            $script:miss++
        } else {
            $status = 'missing'
        }
        $v = ''
    }
    $line = ('{0,-8} {1,-12} {2} {3}' -f $status, $Tool.n, '', $v)
    Write-Output $line
}

$ok = 0
$miss = 0

Write-Output ('Profile:        {0}' -f $Profile)
Write-Output ('Required:       {0} tool(s)' -f $def.Required.Count)
Write-Output ('Optional:       {0} tool(s)' -f $def.Optional.Count)
Write-Output 'Tool     Status       Version'
Write-Output '----     ------       -------'

foreach ($t in $def.Required) { Test-Tool -Tool $t -Required $true }
if (-not $RequiredOnly) {
    foreach ($t in $def.Optional) { Test-Tool -Tool $t -Required $false }
}

Write-Output ''
Write-Output ('Summary: {0} OK, {1} missing required' -f $ok, $miss)

if ($miss -gt 0) { exit 1 } else { exit 0 }