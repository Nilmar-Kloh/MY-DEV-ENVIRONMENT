#!/usr/bin/env pwsh
# --------------------------------------------------
# scripts/inventory/windows.ps1
#
# Purpose
#   Inspect a Windows workstation (host + WSL2 if present) and emit a
#   sanitized inventory suitable for review and migration planning.
#
# This script is READ-ONLY. It does not modify the system.
#
# Output
#   Writes timestamped Markdown/CSV-style files to inventory/raw/.
#
# Usage
#   pwsh scripts/inventory/windows.ps1
#   pwsh scripts/inventory/windows.ps1 -Verbose
#
# Safety
#   Never prints secret values. Outputs variable NAMES, never contents.
# --------------------------------------------------

[CmdletBinding()]
param(
    [switch]$Verbose
)

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot  = Resolve-Path "$ScriptDir/../.."
$RawDir    = Join-Path $RepoRoot 'inventory/raw'
New-Item -ItemType Directory -Force -Path $RawDir | Out-Null

$Timestamp = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ')

function Section($name) {
    Write-Host ""
    Write-Host "=== $name ==="
}

# --------------------------------------------------
# Host machine
# --------------------------------------------------
Section "machine"
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor

@"
# Windows host
- Date (UTC): $Timestamp
- Hostname: $env:COMPUTERNAME
- Windows version: $($os.Caption) $($os.Version)
- Build: $($os.BuildNumber)
- Architecture: $($os.OSArchitecture)
- Manufacturer: $($cs.Manufacturer)
- Model: $($cs.Model)
- CPU: $($cpu.Name)
- PowerShell: $($PSVersionTable.PSVersion)
- Logged-in user: $env:USERNAME
- User domain: $env:USERDOMAIN
"@ | Out-File "$RawDir/machine.md" -Encoding utf8

# --------------------------------------------------
# winget
# --------------------------------------------------
Section "winget"
if (Get-Command winget -ErrorAction SilentlyContinue) {
    $wingetVer = (winget --version) 2>$null
    "$wingetVer" | Out-File "$RawDir/winget-version.txt" -Encoding utf8
    winget list --disable-interactivity 2>$null | Out-File "$RawDir/winget-list.txt" -Encoding utf8
    Write-Host "winget: $wingetVer"
    Write-Host "Installed packages written to winget-list.txt"
} else {
    "winget not installed" | Out-File "$RawDir/winget-version.txt" -Encoding utf8
    Write-Host "winget not installed."
}

# --------------------------------------------------
# CLI tools — targeted list
# --------------------------------------------------
Section "cli-tools"
$targets = @(
    'git','gh','go','node','npm','pnpm','yarn',
    'python','python3','pip','pipx','uv','pyenv',
    'ruff','mypy','pytest','black','isort','uvicorn',
    'docker','colima','podman','nerdctl',
    'kubectl','helm','k9s',
    'terraform','tofu','ansible','packer',
    'aws','gcloud','az',
    'psql','redis-cli','sqlite3','mongosh',
    'ffmpeg','jq','yq','bat','eza','fd','ripgrep','fzf','zoxide','starship','tmux',
    'mkcert','ngrok',
    'code','cursor','code-insiders',
    'ssh','ssh-add','scp','rsync',
    'make','cmake','gcc','clang',
    'java','javac','mvn','gradle',
    'ruby','gem','bundle','cargo','rustc','rustup'
)

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine("# CLI tools")
[void]$sb.AppendLine()
[void]$sb.AppendLine(("{0,-22} {1,-12} {2}" -f "TOOL","FOUND","VERSION"))
[void]$sb.AppendLine(("{0,-22} {1,-12} {2}" -f "----","-----","-------"))
foreach ($t in $targets) {
    $found = Get-Command $t -ErrorAction SilentlyContinue
    if ($found) {
        try {
            $v = (& $t --version 2>&1 | Select-Object -First 1) -replace "`n"," "
            if (-not $v) { $v = "(version probe failed)" }
        } catch {
            $v = "(version probe failed)"
        }
        [void]$sb.AppendLine(("{0,-22} {1,-12} {2}" -f $t,"yes",$v))
    } else {
        [void]$sb.AppendLine(("{0,-22} {1,-12} {2}" -f $t,"no",""))
    }
}
$sb.ToString() | Out-File "$RawDir/cli-tools.txt" -Encoding utf8
Write-Host "Wrote cli-tools.txt"

# --------------------------------------------------
# Languages
# --------------------------------------------------
Section "languages"
$langPairs = @(
    @{n='python';c='python --version'},
    @{n='go';c='go version'},
    @{n='node';c='node --version'},
    @{n='npm';c='npm --version'},
    @{n='pnpm';c='pnpm --version'},
    @{n='yarn';c='yarn --version'},
    @{n='ruby';c='ruby --version'},
    @{n='java';c='java -version'},
    @{n='rust';c='rustc --version'},
    @{n='cargo';c='cargo --version'},
    @{n='dotnet';c='dotnet --version'}
)

$langBuf = [System.Text.StringBuilder]::new()
[void]$langBuf.AppendLine("# Languages")
[void]$langBuf.AppendLine()
foreach ($p in $langPairs) {
    $cmdParts = $p.c.Split(' ')
    $bin = $cmdParts[0]
    if (Get-Command $bin -ErrorAction SilentlyContinue) {
        try {
            # Capture stdout + stderr. A non-zero exit is acceptable —
            # some CLIs write version info to stderr.
            $out = & $bin $cmdParts[1..($cmdParts.Length-1)] 2>&1 | Select-Object -First 1
            if (-not $out) { $out = '(no output)' }
        } catch {
            $out = "(error: $($_.Exception.Message))"
        }
        [void]$langBuf.AppendLine("- **$($p.n)**: $out")
    }
}
$langBuf.ToString() | Out-File "$RawDir/languages.txt" -Encoding utf8

# --------------------------------------------------
# Git (sanitized)
# --------------------------------------------------
Section "git"
if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitLines = git config --global --list 2>$null
    $sanitized = $gitLines | ForEach-Object {
        $line = $_
        if ($line -match '^(user\.name|user\.email|user\.signingkey|alias\.|core\.editor|core\.autocrlf|core\.excludesfile|init\.defaultBranch|push\.autoSetupRemote|fetch\.prune|pull\.rebase|rerere\.enabled|rebase\.autosquash|color\.ui|credential\.helper|gpg\.format)=') {
            $key = ($line -split '=',2)[0]
            "$key=<REDACTED>"
        } else {
            $null
        }
    } | Where-Object { $_ }

    $gitBuf = [System.Text.StringBuilder]::new()
    [void]$gitBuf.AppendLine("# Git (sanitized)")
    [void]$gitBuf.AppendLine()
    [void]$gitBuf.AppendLine("## Version")
    [void]$gitBuf.AppendLine((git --version))
    [void]$gitBuf.AppendLine()
    [void]$gitBuf.AppendLine("## Safe configuration (values redacted)")
    foreach ($l in $sanitized) { [void]$gitBuf.AppendLine("- $l") }
    $gitBuf.ToString() | Out-File "$RawDir/git.md" -Encoding utf8
}

# --------------------------------------------------
# SSH (sanitized — never key contents)
# --------------------------------------------------
Section "ssh"
$sshDir = Join-Path $env:USERPROFILE '.ssh'
if (Test-Path $sshDir) {
    $sshBuf = [System.Text.StringBuilder]::new()
    [void]$sshBuf.AppendLine("# SSH (sanitized)")
    [void]$sshBuf.AppendLine()
    [void]$sshBuf.AppendLine("## Files present (filenames only)")
    Get-ChildItem -Path $sshDir -File | ForEach-Object {
        [void]$sshBuf.AppendLine("- $($_.Name) ($($_.Length) bytes)")
    }
    [void]$sshBuf.AppendLine()
    $cfg = Join-Path $sshDir 'config'
    if (Test-Path $cfg) {
        [void]$sshBuf.AppendLine("## Config (directive keys only, values redacted)")
        Get-Content $cfg | ForEach-Object {
            if ($_ -match '^\s*#' -or $_ -match '^\s*$') { $line = $_ }
            else {
                $key = ($_ -split '\s+',2)[0]
                $line = "$key <REDACTED>"
            }
            [void]$sshBuf.AppendLine($line)
        }
    }
    [void]$sshBuf.AppendLine()
    [void]$sshBuf.AppendLine("## ssh-agent status (first 5 lines)")
    try {
        ssh-add -l 2>&1 | Select-Object -First 5 | ForEach-Object {
            [void]$sshBuf.AppendLine("- $_")
        }
    } catch {
        [void]$sshBuf.AppendLine("- (no agent or no keys)")
    }
    $sshBuf.ToString() | Out-File "$RawDir/ssh.md" -Encoding utf8
}

# --------------------------------------------------
# WSL distros (if installed)
# --------------------------------------------------
Section "wsl"
if (Get-Command wsl -ErrorAction SilentlyContinue) {
    $wslBuf = [System.Text.StringBuilder]::new()
    [void]$wslBuf.AppendLine("# WSL")
    [void]$wslBuf.AppendLine()
    [void]$wslBuf.AppendLine("## Distros")
    [void]$wslBuf.AppendLine((wsl -l -v 2>&1))
    [void]$wslBuf.AppendLine()
    [void]$wslBuf.AppendLine("## Default distro")
    [void]$wslBuf.AppendLine((wsl -l 2>&1 | Select-String 'Default'))
    $wslBuf.ToString() | Out-File "$RawDir/wsl.md" -Encoding utf8
    Write-Host "Wrote wsl.md"
} else {
    Write-Host "WSL not installed."
}

# --------------------------------------------------
# Container runtimes
# --------------------------------------------------
Section "containers"
$contBuf = [System.Text.StringBuilder]::new()
[void]$contBuf.AppendLine("# Container runtimes")
[void]$contBuf.AppendLine()
foreach ($t in @('docker','colima','podman','nerdctl')) {
    if (Get-Command $t -ErrorAction SilentlyContinue) {
        $v = (& $t --version 2>&1 | Select-Object -First 1)
        [void]$contBuf.AppendLine("- $t`: $v")
    }
}
if (Get-Command docker -ErrorAction SilentlyContinue) {
    [void]$contBuf.AppendLine()
    [void]$contBuf.AppendLine("## Docker context (no auth)")
    [void]$contBuf.AppendLine((docker context ls 2>&1))
}
$contBuf.ToString() | Out-File "$RawDir/containers.txt" -Encoding utf8

# --------------------------------------------------
# Environment variable NAMES (no values)
# --------------------------------------------------
Section "env-variable-names"
[System.Environment]::GetEnvironmentVariables() |
    ForEach-Object { $_.Keys } |
    Sort-Object -Unique |
    Out-File "$RawDir/env-variable-names.txt" -Encoding utf8
Write-Host "Wrote env-variable-names.txt (names only)"

# --------------------------------------------------
# Summary
# --------------------------------------------------
Section "summary"
Write-Host "Raw inventory written to: $RawDir"
Get-ChildItem $RawDir | Format-Table Name, Length -AutoSize