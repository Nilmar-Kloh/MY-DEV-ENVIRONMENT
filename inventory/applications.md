# Applications — curated inventory

Source of truth: `bash scripts/inventory/macos.sh` (output in
`inventory/raw/applications.txt`, gitignored local evidence).

Decision vocabulary (Task 5 definitions):

- **`[KEEP]`** — deliberate personal environment. Recreate on the Dell / WSL2.
- **`[REPLACE]`** — capability survives, implementation changes.
- **`[OPTIONAL]`** — useful, not required for initial bootstrap. Must not block validation.
- **`[COMPANY]`** — belongs to or is managed by the outgoing employer. Do not migrate.
- **`[DROP]`** — installed but not worth deliberately recreating.
- **`<USER_REVIEW>`** — evidence insufficient; owner decides.

Every row below was detected by the live run unless noted otherwise.

## Development — KEEP / REPLACE

| Application | Decision | Target / notes |
| --- | --- | --- |
| Visual Studio Code | [KEEP] | `winget install Microsoft.VisualStudioCode`. Primary editor. |
| iTerm | [REPLACE] | Windows Terminal (`winget install Microsoft.WindowsTerminal`); shell itself moves to WSL2 zsh. |
| DBeaver | [KEEP] | `winget install DBeaver.DBeaverCommunity`. Primary DB GUI. |
| OpenCode | [KEEP] | Declared in Brewfile → deliberate. Cross-platform download on the Dell. |
| Obsidian | [KEEP] | `winget install Obsidian.Obsidian`. Personal notes system. |

## Development — OPTIONAL (redundant / review)

| Application | Decision | Target / notes |
| --- | --- | --- |
| Cursor | [OPTIONAL] | Second editor alongside VS Code. No Cursor-specific config in repo. Recreate only if it earns its place. |
| GitHub Desktop | [OPTIONAL] | Overlaps with CLI + Fork. Recreate only if GUI Git workflow is wanted. |
| Fork | [OPTIONAL] | Overlaps with CLI + GitHub Desktop. Pick at most one Git GUI. `<USER_REVIEW>`: choose Fork vs GitHub Desktop vs neither. |
| ChatGPT (app) | [OPTIONAL] | Browser session suffices. |
| Claude (app) | [OPTIONAL] | Browser session suffices. |

## Productivity

| Application | Decision | Target / notes |
| --- | --- | --- |
| Raycast | [REPLACE] | PowerToys Run (`winget install Microsoft.PowerToys`). |
| Rectangle | [REPLACE] | PowerToys FancyZones (same install). |
| Keka | [REPLACE] | 7-Zip (`winget install 7zip.7zip`). |
| LocalSend | [OPTIONAL] | `winget install LocalSend.LocalSend`. Useful, not bootstrap. |
| Dropbox | [OPTIONAL] | Personal account. Install only if still used. |
| AltTab | [DROP] | macOS gap-filler; Windows Alt-Tab is native. |
| Dropover | [DROP] | macOS drag-drop shelf; no Windows equivalent needed. |
| BetterDisplay | [DROP] | macOS display-quirk tool; use Windows Display settings. |
| Windows App | [OPTIONAL] | Microsoft remote-desktop client; handy on Windows, not bootstrap. |

## Browsers

| Application | Decision | Target / notes |
| --- | --- | --- |
| Google Chrome | [KEEP] | Personal browser. Install per corporate policy on the Dell. |
| Google Chrome 2 | [DROP] | Duplicate install. |
| Microsoft Edge | [COMPANY] | Managed by employer on the Mac; the Dell ships its own Edge. |
| WhatsApp | [DROP] | Phone companion app, not part of the dev environment. |

## Media / creative — all OPTIONAL, none bootstrap

The Dell is a development workstation, not a media workstation. None of
these block validation. Recreate individually on personal hardware as
needed; do not bundle into the developer bootstrap.

| Application | Decision | Notes |
| --- | --- | --- |
| Adobe Premiere Pro (Beta / 2026) | [OPTIONAL] | personal license |
| Adobe Media Encoder (Beta / 2026) | [OPTIONAL] | personal license |
| DaVinci Resolve (+ Uninstall Resolve) | [OPTIONAL] | free version available |
| DaVinci Control Panels Setup | [OPTIONAL] | Resolve peripheral |
| Blackmagic RAW Player / Speed Test / Remote Monitor / Proxy Generator | [OPTIONAL] | blackmagicdesign.com |
| Fairlight Studio Utility | [OPTIONAL] | Resolve ecosystem |
| Cavalry | [OPTIONAL] | personal |
| Insta360 Studio | [OPTIONAL] | personal |
| DJI Studio | [OPTIONAL] | personal |
| Blender | [OPTIONAL] | `winget install BlenderFoundation.Blender` |
| OBS | [OPTIONAL] | `winget install OBSProject.OBSStudio` |
| Shutter Encoder | [OPTIONAL] | personal |
| Affinity | [OPTIONAL] | personal license |

## Hardware peripherals — all OPTIONAL

Tied to physical devices, not to the Dell bootstrap. Install from the
vendor when the device is in use.

| Application | Decision | Notes |
| --- | --- | --- |
| Wacom Center / Display Settings / Tablet Utility | [OPTIONAL] | wacom.com |
| Contour Design Multimedia | [OPTIONAL] | contourdesign.com |
| Logi Options+ / LogiPluginService / Driver Installer | [OPTIONAL] | `winget install Logitech.OptionsPlus` |
| DisplayLink Manager | [OPTIONAL] | displaylink.com |

## Company-managed — DO NOT migrate

Detected on the Mac; belong to the outgoing employer. No migration
instructions. Where the new employer may provide an equivalent, the
marker is `<REQUEST_FROM_IT>`.

| Application | Purpose | New-employer equivalent |
| --- | --- | --- |
| JamfProtect | endpoint security (MDM) | `<REQUEST_FROM_IT>` |
| Kaspersky Anti-Virus For Mac | endpoint security (AV) | `<REQUEST_FROM_IT>` |
| GlobalProtect | corporate VPN | `<REQUEST_FROM_IT>` |
| Splashtop On-Prem | remote support | `<REQUEST_FROM_IT>` |
| Central de Software | corporate software portal | `<REQUEST_FROM_IT>` |
| Setup Manager / Setup Checklist (+ Utilities copy) | corporate onboarding | — (old-employer onboarding, ignore) |
| IBM Aspera Connect / Crypt / Launcher | corporate file transfer | `<REQUEST_FROM_IT>` |
| Microsoft Teams | corporate comms (corporate account only) | `<REQUEST_FROM_IT>` |
| Microsoft Outlook / Word / Excel / PowerPoint | corporate account | `<REQUEST_FROM_IT>` (personal M365 is separate) |
| Microsoft OneDrive | corporate account sync | `<REQUEST_FROM_IT>` (personal OneDrive is separate) |
| VNC Viewer | corporate remote access | `<REQUEST_FROM_IT>` |
| AnyDesk | corporate remote access | `<REQUEST_FROM_IT>` |

## Notes on detection gaps

These were NOT in the live `inventory/raw/applications.txt`:

- Docker Desktop (no `/Applications` entry; CLI runtime present — see `inventory/containers.md`)
- WSL2 / Windows Terminal (not applicable to macOS)
