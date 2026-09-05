# Applications — current inventory (Mac)

Captured from a live run of `bash scripts/inventory/macos.sh` on the
outgoing MacBook. See `inventory/raw/applications.txt` for the raw
output. Each item below has been manually reviewed and tagged.

Tags:

- `[essential]` — required for daily development
- `[useful]` — improves workflow, acceptable to postpone
- `[optional]` — nice to have, low cost to add later
- `[company]` — provided/managed by current employer; do NOT migrate
- `[personal]` — personal, OK to reinstall on personal hardware
- `[excluded]` — intentional non-migration

## Development

| Application | Tag | Migration |
| --- | --- | --- |
| iTerm | [essential] | `winget install Microsoft.WindowsTerminal` (WSL2 zsh) |
| Visual Studio Code | [essential] | `winget install Microsoft.VisualStudioCode` |
| Cursor | [useful] | download from cursor.sh |
| DBeaver | [useful] | `winget install DBeaver.DBeaverCommunity` |
| Obsidian | [essential] | `winget install Obsidian.Obsidian` |
| GitHub Desktop | [optional] | `winget install GitHub.GitHubDesktop` |
| Fork | [optional] | download from git-fork.com |
| OpenCode | [useful] | personal — same product available cross-platform |
| ChatGPT | [optional] | personal browser session |
| Claude | [optional] | personal browser session |

## Productivity

| Application | Tag | Migration |
| --- | --- | --- |
| Raycast | [useful] | Windows: PowerToys Run (`winget install Microsoft.PowerToys`) |
| Rectangle | [optional] | Windows: PowerToys FancyZones |
| AltTab | [optional] | Windows: built-in alt-tab or PowerToys |
| Keka | [optional] | Windows: 7-Zip (`winget install 7zip.7zip`) |
| Dropover | [optional] | skip |
| BetterDisplay | [optional] | Windows Display settings |
| LocalSend | [optional] | `winget install LocalSend.LocalSend` |
| OneDrive | [company] | personal Microsoft account on personal machine |
| Dropbox | [personal] | `winget install Dropbox.Dropbox` |

## Browsers

| Application | Tag | Migration |
| --- | --- | --- |
| Google Chrome | [useful] | already on Windows by default usually |
| Google Chrome 2 | [excluded] | duplicate install — likely test profile |
| Microsoft Edge | [company] | managed by employer |
| Windows App | [optional] | n/a |
| WhatsApp | [optional] | install on personal phone |

## Media (creative / personal)

| Application | Tag | Migration |
| --- | --- | --- |
| Adobe Premiere Pro (Beta) | [optional] | license is personal/CC; install on personal machine |
| Adobe Premiere Pro 2026 | [optional] | same |
| Adobe Media Encoder (Beta) | [optional] | same |
| Adobe Media Encoder 2026 | [optional] | same |
| DaVinci Resolve | [optional] | free; install on personal machine |
| Cavalry | [optional] | personal |
| Insta360 Studio | [optional] | personal |
| DJI Studio | [optional] | personal |
| Blender | [optional] | personal |
| OBS | [optional] | `winget install OBSProject.OBSStudio` |
| Shutter Encoder | [optional] | personal |
| Affinity | [optional] | personal license |

## Hardware peripherals

| Application | Tag | Migration |
| --- | --- | --- |
| Wacom Center / Display / Tablet Utility | [optional] | install from wacom.com on personal machine |
| Contour Design Multimedia | [optional] | install from contourdesign.com |
| Logi Options+ (logioptionsplus / LogiPluginService / Driver Installer) | [optional] | `winget install Logitech.OptionsPlus` |
| DisplayLink Manager | [optional] | install from displaylink.com |
| Blackmagic RAW Player / Speed Test / Remote Monitor / Proxy Generator | [optional] | install from blackmagicdesign.com |
| Fairlight Studio Utility | [optional] | part of DaVinci Resolve ecosystem |

## Company-managed (DO NOT migrate)

These are provided by the current employer. Do not commit, copy, or
transfer. Document only the name.

| Application | Purpose |
| --- | --- |
| JamfProtect | endpoint security (MDM) |
| Kaspersky Anti-Virus For Mac | endpoint security (AV) |
| GlobalProtect | corporate VPN |
| Splashtop On-Prem | remote support (corp) |
| Central de Software | corporate software portal |
| Setup Manager / Setup Checklist | corporate onboarding |
| IBM Aspera Connect / Crypt / Launcher | corporate file transfer |

## Excluded (intentional)

| Application | Reason |
| --- | --- |
| Microsoft Teams | corporate account only |
| Microsoft Outlook / Word / Excel / PowerPoint | corporate account; personal Microsoft 365 on personal machine is separate |
| VNC Viewer | corporate remote access |
| AnyDesk | corporate remote access |