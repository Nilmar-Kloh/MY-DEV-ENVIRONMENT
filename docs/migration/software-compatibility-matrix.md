# Software compatibility matrix — macOS → Windows 11 / Debian / Omarchy

Source of truth: `inventory/raw/applications.txt` (live run, gitignored)
as curated in `inventory/applications.md` and `docs/migration/manifest.md`.

This document is **informational**. Compatibility does NOT mean desired
installation. Only `docs/migration/manifest.md` determines target
intent. Do not add rows from here to any winget manifest, install
script, validator, or bootstrap without a manifest decision.

## Status vocabulary

Per-target status uses the controlled vocabulary. The core rule:
**packaging availability is not vendor support.** A community Flatpak,
an AUR package, an unofficial fork, or a Wine path must never read as
equivalent to a vendor-native build.

```text
NATIVE       vendor ships an official native build for this OS
             (installer, vendor repo/.deb, official AppImage, official
             install script)
ARCH         Arch official repositories carry the package (distro
             packaging, NOT vendor support; Omarchy column only)
AUR          community AUR packaging only (never vendor support;
             Omarchy column only; verified package names cited)
WEB          browser workflow is viable, no native client needed
FLATPAK      Flatpak path exists — cell must say official or community
APPIMAGE     AppImage exists — cell must say official or unofficial
CLI-ONLY     only command-line functionality is realistic
WSL          practical via WSL rather than native Windows GUI
ALTERNATIVE  original absent; a replacement fills the role
UNSUPPORTED  no realistic supported path (incl. Wine-only routes,
             which are named, never implied as parity)
UNKNOWN      evidence insufficient
```

`COMPANY` appears **only** in the Decision column (migration intent),
never as a platform-compatibility status. Platform cells for
employer-managed software describe actual vendor compatibility; the
Decision column carries the do-not-migrate ruling.

Omarchy cells use one of: official Linux application (vendor build
runs on Arch) · `ARCH` (Arch extra/official repo) · `AUR` (named
community package) · `WEB` · `ALTERNATIVE` · `UNSUPPORTED` ·
`UNKNOWN`. Unverified AUR guesses are marked UNKNOWN, not LIKELY.

Confidence: **HIGH** = official vendor/platform evidence,
**MEDIUM** = reliable package/community evidence, **LOW** = inference
or unofficial compatibility.

Decision vocabulary is unchanged: `KEEP` `REPLACE` `OPTIONAL`
`COMPANY` `DROP` `USER_REVIEW`.

## Totals

```text
Total Mac applications detected:  70 raw entries → 64 mapped rows
                                    (3 IBM Aspera components → 1 row;
                                     4 Logi Options+ entries → 1 row;
                                     Setup Manager in 2 locations → 1 row;
                                     Google Chrome 2 kept as own row: duplicate)

Decisions (unchanged this pass):
KEEP:        5 (VS Code, OpenCode, DBeaver, Chrome, Obsidian)
REPLACE:     4 (iTerm2, Raycast, Rectangle, Keka)
OPTIONAL:   29 (media suite, peripherals, secondary tools)
COMPANY:    17 (security, VPN, comms, office, sync, remote, onboarding, …)
DROP:        6 (Chrome 2, AltTab, Dropover, BetterDisplay, Uninstall Resolve, WhatsApp)
USER_REVIEW: 3 (Cursor; Fork vs GitHub Desktop vs neither)

Support quality — Windows 11 (64 rows):
  vendor-NATIVE:  51 (includes employer-provided Office/Teams/corp AV/VPN:
                   native builds, corp-provisioned — Decision stays COMPANY)
  ALTERNATIVE:     6 (Terminal, PowerToys Run, FancyZones, 7-Zip, Remmina-class, Solaar-class)
  UNSUPPORTED:     1 (Dropover)
  UNKNOWN:         4 (JamfProtect, Central de Software, Setup ×2 — internal tooling)
  no target:       2 (Chrome 2, Uninstall Resolve)

Support quality — Debian (64 rows):
  vendor-native/official: 17 (VS Code, Cursor, OpenCode, DBeaver, Chrome,
                   Edge, Obsidian [.deb+AppImage], Dropbox, AnyDesk, VNC,
                   Blender, OBS, Shutter Encoder, Kaspersky, GlobalProtect,
                   Aspera; LocalSend upstream builds unverified)
  community/unofficial:   8 (GitHub Desktop shiftkey fork; DisplayLink
                   install script; Contour community drivers; Solaar;
                   abraunegg OneDrive CLI-only; Affinity Wine; Resolve
                   compat route; WhatsApp wrappers)
  WEB-only:               8 (Teams, Office ×4, ChatGPT, Claude + WhatsApp official route)
  ALTERNATIVE (role replacement): 13 (terminals, launchers, WM tools, archivers,
                   RDP clients, tablet/input stacks)
  UNSUPPORTED:           11 (Adobe ×4, Affinity-native, Cavalry, Insta360, DJI,
                   Fork, Resolve-official, Dropover)
  UNKNOWN:               11 (6 Blackmagic satellites, JamfProtect, Splashtop On-Prem,
                   Central de Software, Setup ×2)
  no target:              2

Support quality — Omarchy (64 rows):
  official Linux app (vendor build runs): 1 (OpenCode, install script)
  ARCH (official repo, distro packaging): 5 (code, dbeaver, obsidian, blender, obs)
  AUR community (verified package names): 10 (cursor-bin, github-desktop-bin
                   [unofficial fork], google-chrome, microsoft-edge-stable-bin,
                   dropbox, anydesk-bin, shutter-encoder-bin, displaylink,
                   localsend, realvnc-vnc-viewer [upstream flags out-of-date])
  WEB-only:               8 (Teams, Office ×4, ChatGPT, Claude, WhatsApp official route)
  ALTERNATIVE (role/WM/community): 12 (Foot/terminals, Omarchy Menu, Hyprland
                   tiling, archivers, Remmina/FreeRDP, libwacom/Solaar stacks,
                   community Shuttle driver)
  UNSUPPORTED:           11 (Adobe ×4, Affinity-native, Cavalry, Insta360, DJI,
                   Fork, Resolve-official; community Wine/AUR-compat exists
                   for Affinity + Resolve but is not support)
  UNKNOWN:               15 (OneDrive AUR presence, 6 Blackmagic satellites,
                   8 corporate rows)
  no target:              2
```

## Target assumptions

- **Windows 11**: corporate Dell, WSL2 available, winget preferred,
  corporate policy may restrict installs.
- **Debian**: Debian Stable, apt primary; Flatpak/AppImage/upstream
  binaries where justified. Ubuntu-only `.deb`s are flagged, not
  assumed.
- **Omarchy**: Arch-based Hyprland/Wayland desktop (pacman + AUR;
  per the Omarchy manual: Foot is the default terminal with
  Alacritty/Ghostty/Kitty as supported options, the Omarchy Menu on
  Super+Space is the launcher, tmux-first workflow; ships Obsidian,
  Chromium, OBS, Neovim, LibreOffice). Linux-compatible ≠
  automatically Omarchy-compatible: tiling WM absorbs some utilities
  entirely; X11-only apps and enterprise-distro-only binaries are
  flagged. Uncertain rows are UNKNOWN, never invented certainty.

## Development

| Application | Purpose | Decision | Windows | Debian | Omarchy | Preferred | Conf | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Visual Studio Code | primary editor | KEEP | NATIVE (`Microsoft.VisualStudioCode`) | NATIVE (MS apt repo `.deb`) | ARCH (`code`, Arch extra — distro packaging, not vendor) | Windows host + Remote-WSL | HIGH | Strip macOS-only keys on Windows |
| Cursor | secondary editor | USER_REVIEW | NATIVE (cursor.com) | NATIVE (`.deb`/AppImage, vendor) | AUR community (verified `cursor-bin`) | Windows host if kept | MEDIUM | No repo config; earn its place |
| OpenCode | terminal AI coding agent | KEEP | NATIVE (install script, terminal) | NATIVE (install script) | NATIVE (install script) | WSL | MEDIUM | CLI tool; no desktop integration needed |
| DBeaver Community | DB GUI | KEEP | NATIVE (`DBeaver.DBeaverCommunity`) | NATIVE (vendor `.deb`/repo) | ARCH (`dbeaver`, Arch extra — distro packaging, not vendor) | Windows host | HIGH | Easy win: native everywhere |
| Fork | Git GUI client ($60) | USER_REVIEW | NATIVE (vendor exe) | UNSUPPORTED (Mac+Win only per vendor) | UNSUPPORTED | Windows host if kept | HIGH | Linux alt: Sublime Merge (native) or lazygit (CLI) |
| GitHub Desktop | Git GUI client | USER_REVIEW | NATIVE (`GitHub.GitHubDesktop`) | FLATPAK / `.deb` — unofficial community fork ONLY (shiftkey; lags upstream; no official Linux build per desktop/desktop#21085) | AUR community, same unofficial fork (verified `github-desktop-bin`) | Windows host if kept | MEDIUM | Pick at most one Git GUI; CLI covers the rest |
| ChatGPT (desktop app) | AI assistant | OPTIONAL | NATIVE (official app) | WEB (no Linux app) | WEB | Web | MEDIUM | Browser suffices on Linux |
| Claude (desktop app) | AI assistant | OPTIONAL | NATIVE (official app) | WEB (no Linux app) | WEB | Web | MEDIUM | Browser suffices on Linux |

## Terminal / shell

| Application | Purpose | Decision | Windows | Debian | Omarchy | Preferred | Conf | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| iTerm | terminal emulator | REPLACE | ALTERNATIVE (Windows Terminal) | ALTERNATIVE (Foot/Alacritty/Ghostty/Kitty) | ALTERNATIVE (Foot is Omarchy default; Alacritty/Ghostty/Kitty supported per manual) | Windows Terminal + WSL zsh | HIGH | macOS-only; capability survives |

## Browser / communication

| Application | Purpose | Decision | Windows | Debian | Omarchy | Preferred | Conf | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Google Chrome | browser | KEEP | NATIVE | NATIVE (Google `.deb`) | AUR community (verified `google-chrome`) | Windows host | HIGH | Per corporate policy on Dell |
| Google Chrome 2 | duplicate install | DROP | — | — | — | Do not migrate | HIGH | Duplicate; drop |
| Microsoft Edge | browser (managed) | COMPANY | NATIVE (ships) | NATIVE (MS apt repo) | AUR community (verified `microsoft-edge-stable-bin`) | Do not migrate | MEDIUM | Employer-managed on Mac |
| Microsoft Teams | meetings/chat (corp) | COMPANY | NATIVE | WEB (PWA only) | WEB | Do not migrate | HIGH | `<REQUEST_FROM_IT>` |
| WhatsApp | messaging | DROP | NATIVE (Store) | WEB (official route; unofficial wrappers: Whatsie Flatpak, snaps) | WEB (community wrappers; AUR presence unverified) | Do not migrate (web if ever needed) | MEDIUM | No official Linux client; wrappers are Web-backed; phone-first app, not dev env |
| Microsoft Outlook | mail (corp) | COMPANY | NATIVE | WEB (M365 web) | WEB | Do not migrate | HIGH | `<REQUEST_FROM_IT>` |
| Microsoft Word | docs (corp) | COMPANY | NATIVE | WEB (M365 web) | WEB | Do not migrate | HIGH | `<REQUEST_FROM_IT>` |
| Microsoft Excel | sheets (corp) | COMPANY | NATIVE | WEB (M365 web) | WEB | Do not migrate | HIGH | `<REQUEST_FROM_IT>` |
| Microsoft PowerPoint | slides (corp) | COMPANY | NATIVE | WEB (M365 web) | WEB | Do not migrate | HIGH | `<REQUEST_FROM_IT>` |

## Productivity

| Application | Purpose | Decision | Windows | Debian | Omarchy | Preferred | Conf | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Obsidian | notes | KEEP | NATIVE (`Obsidian.Obsidian`) | NATIVE (official `.deb` + AppImage; Flatpak is community-maintained per vendor download page) | ARCH (`obsidian`, Arch extra) | Windows host | HIGH | Easy win: vendor-supported on all three |
| Raycast | launcher | REPLACE | ALTERNATIVE (PowerToys Run) | ALTERNATIVE (Ulauncher/Albert; scope differs) | ALTERNATIVE (Omarchy Menu on Super+Space covers launcher role per manual) | Per-OS launcher | HIGH | macOS-only; role absorbed |
| Rectangle | window tiling | REPLACE | ALTERNATIVE (FancyZones) | ALTERNATIVE (WM-dependent) | ALTERNATIVE (Hyprland tiles natively; no clone needed) | Per-OS WM | HIGH | macOS-only |
| AltTab | window switcher | DROP | ALTERNATIVE (native Alt-Tab) | ALTERNATIVE (WM-dependent) | ALTERNATIVE (Hyprland workspaces cover role) | Do not migrate | HIGH | macOS gap-filler |
| BetterDisplay | display mgmt | DROP | ALTERNATIVE (Display settings) | ALTERNATIVE (WM/output config) | ALTERNATIVE (Hyprland output config) | Do not migrate | HIGH | macOS display-quirk tool |
| Dropover | drag-drop shelf | DROP | UNSUPPORTED | UNSUPPORTED | UNSUPPORTED | Do not migrate | HIGH | macOS-only utility |
| Keka | archiver | REPLACE | ALTERNATIVE (7-Zip) | ALTERNATIVE (File Roller/Ark/p7zip) | ALTERNATIVE (archive tools) | Per-OS tool | HIGH | macOS-only |
| LocalSend | LAN file share | OPTIONAL | NATIVE (winget) | NATIVE (upstream `.deb`/AppImage per project releases — presence unverified, confirm before relying) | AUR community (verified `localsend`; not Arch extra) | Where needed | MEDIUM | Not bootstrap |
| Dropbox | cloud sync (personal) | OPTIONAL | NATIVE | NATIVE (vendor `.deb` + integration) | AUR community (verified `dropbox`) | Where needed | HIGH | Install only if still used |
| OneDrive | sync (corp acct) | COMPANY | NATIVE | CLI-ONLY community (abraunegg; no Files-On-Demand) | UNKNOWN (likely AUR/community build of same client; unverified) | Do not migrate | MEDIUM | Corp account; personal separate; `<REQUEST_FROM_IT>` |

## Remote access

| Application | Purpose | Decision | Windows | Debian | Omarchy | Preferred | Conf | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| AnyDesk | remote desktop | COMPANY | NATIVE | NATIVE (vendor `.deb` + APT repo) | AUR community (verified `anydesk-bin`) | Do not migrate | HIGH | Corporate remote-access use; vendor ships all platforms |
| VNC Viewer (RealVNC) | VNC client | COMPANY | NATIVE | NATIVE (vendor `.deb`/rpm) | AUR community (verified `realvnc-vnc-viewer`; AUR flags it out-of-date — staleness risk) | Do not migrate | MEDIUM | Corporate remote-access use |
| Windows App | MS remote client | OPTIONAL | NATIVE (ships) | ALTERNATIVE (Remmina/FreeRDP) | ALTERNATIVE (Remmina/FreeRDP; Arch-extra presence unverified) | Where needed | MEDIUM | Not the same as generic RDP on Linux |

## Media / video

| Application | Purpose | Decision | Windows | Debian | Omarchy | Preferred | Conf | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Adobe Premiere Pro (Beta) | video editor | OPTIONAL | NATIVE | UNSUPPORTED (no Linux; Wine ≠ parity) | UNSUPPORTED | Personal HW if needed | HIGH | None of Adobe CC exists on Linux |
| Adobe Premiere Pro 2026 | video editor | OPTIONAL | NATIVE | UNSUPPORTED | UNSUPPORTED | Personal HW if needed | HIGH | Same as above |
| Adobe Media Encoder (Beta) | encoder | OPTIONAL | NATIVE | UNSUPPORTED | UNSUPPORTED | Personal HW if needed | HIGH | Same as above |
| Adobe Media Encoder 2026 | encoder | OPTIONAL | NATIVE | UNSUPPORTED | UNSUPPORTED | Personal HW if needed | HIGH | Same as above |
| DaVinci Resolve | editor/color | OPTIONAL | NATIVE | UNSUPPORTED officially — official Linux build exists but Blackmagic supports Rocky Linux 8.6 only, not Debian. Community route: vendor `.run` + MakeResolveDeb, X11 session, H.264/65 free-codec gap | UNSUPPORTED officially — AUR community package (verified `davinci-resolve`) under the same unsupported-compat caveats | Windows if media work continues | HIGH | Test codec+GPU+driver before relying |
| Uninstall Resolve | installer artifact | DROP | — | — | — | Do not migrate | HIGH | Not software |
| DaVinci Control Panels Setup | HW panel config | OPTIONAL | NATIVE (via Desktop Video/Resolve) | UNKNOWN | UNKNOWN | With Resolve if needed | LOW | Tied to panels + Resolve install |
| Blackmagic Proxy Generator | proxy workflow | OPTIONAL | NATIVE (BM suite) | UNKNOWN | UNKNOWN | With Resolve if needed | LOW | Verify against installed Resolve version |
| Blackmagic RAW Player | RAW playback | OPTIONAL | NATIVE (BM suite) | UNKNOWN | UNKNOWN | With Resolve if needed | LOW | BRAW tooling follows Desktop Video/Resolve |
| Blackmagic RAW Speed Test | benchmark | OPTIONAL | NATIVE (BM suite) | UNKNOWN | UNKNOWN | With Resolve if needed | LOW | Same as above |
| Blackmagic Remote Monitor | monitoring | OPTIONAL | NATIVE (BM suite) | UNKNOWN | UNKNOWN | With Resolve if needed | LOW | Same as above |
| Fairlight Studio Utility | audio HW util | OPTIONAL | NATIVE (bundled w/ Resolve) | UNKNOWN | UNKNOWN | With Resolve if needed | LOW | Ships with Resolve installer |
| Cavalry | motion design (now Canva) | OPTIONAL | NATIVE (Win 10+) | UNSUPPORTED (Mac+Win only per vendor) | UNSUPPORTED | Windows if needed | HIGH | No Linux path |
| Insta360 Studio | 360 footage | OPTIONAL | NATIVE | UNSUPPORTED (Win+Mac only; forum asks for Wine) | UNSUPPORTED | Windows if needed | HIGH | No Linux build |
| DJI Studio | 360/aerial editor | OPTIONAL | NATIVE (Win 10+) | UNSUPPORTED (Win+Mac only per DJI FAQ) | UNSUPPORTED | Windows if needed | HIGH | Companion for DJI 360 footage, not a full NLE |
| Blender | 3D suite | OPTIONAL | NATIVE | NATIVE (apt) | ARCH (Arch extra — distro packaging, not vendor) | Where needed | HIGH | Easy win; not bootstrap (media-only) |
| OBS | capture/stream | OPTIONAL | NATIVE | NATIVE (apt; Flathub build is vendor-official) | ARCH (Arch extra — distro packaging, not vendor) | Where needed | HIGH | Easy win; not bootstrap |
| Shutter Encoder | transcoder (FFmpeg) | OPTIONAL | NATIVE | NATIVE (vendor `.deb` + AppImage) | AUR community (verified `shutter-encoder-bin`) | Where needed | HIGH | Rare full-vendor-native media tool; GPL-3.0 |
| Affinity | design suite (now Canva, free) | OPTIONAL | NATIVE | UNSUPPORTED (unofficial Wine/AppImage only: no OpenCL, no sign-in) | UNSUPPORTED (same Wine path) | Windows if needed | HIGH | Native Linux alt: GIMP/Inkscape/Krita; Wine ≠ parity |

## Hardware / peripherals

Driver support ≠ GUI support on Linux: devices often work via kernel
while the vendor control panel does not exist.

| Application | Purpose | Decision | Windows | Debian | Omarchy | Preferred | Conf | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Wacom Center | tablet config | OPTIONAL | NATIVE | ALTERNATIVE (kernel + libwacom; no vendor GUI) | ALTERNATIVE (same stack) | With device | MEDIUM | Pen works; control panel doesn't |
| Wacom Display Settings | display-tablet config | OPTIONAL | NATIVE | ALTERNATIVE (same stack) | ALTERNATIVE (same stack) | With device | MEDIUM | Same as above |
| Wacom Tablet Utility | tablet driver util | OPTIONAL | NATIVE | ALTERNATIVE (same stack) | ALTERNATIVE (same stack) | With device | MEDIUM | Same as above |
| Logi Options+ (app + PluginService + Driver Installer) | mouse/kb config | OPTIONAL | NATIVE (Store/vendor) | ALTERNATIVE (Solaar community project) | ALTERNATIVE (Solaar; AUR presence unverified) | With device | MEDIUM | Basic HID works; per-app profiles don't |
| DisplayLink Manager | USB graphics docks | OPTIONAL | NATIVE (Windows Update/vendor) | ALTERNATIVE (community-only; vendor supports Ubuntu LTS only; Debian via displaylink-debian script + evdi-dkms) | AUR community (verified `displaylink`) | With dock | MEDIUM | Test dock before relying; Wayland caveats |
| Contour Design Multimedia | jog/shuttle config | OPTIONAL | NATIVE (vendor driver) | ALTERNATIVE (community-only; shuttle-go/OpenContourShuttle, unofficial; no vendor Linux GUI) | ALTERNATIVE (community-only; same projects) | With device | MEDIUM | Device usable via community drivers; no vendor GUI |

## Corporate / security

No migration instructions. Equivalents are `<REQUEST_FROM_IT>`.

| Application | Purpose | Decision | Windows | Debian | Omarchy | Preferred | Conf | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| JamfProtect | endpoint security | COMPANY | UNKNOWN (Apple-MDM-centric product; new employer owns the stack) | UNKNOWN | UNKNOWN | Do not migrate | LOW | Old-employer deployment; never transfer config |
| Kaspersky Anti-Virus For Mac | antivirus | COMPANY | NATIVE (vendor Windows products) | NATIVE (vendor Endpoint for Linux) | UNKNOWN | Do not migrate | MEDIUM | Corp deployment; never transfer config |
| GlobalProtect | VPN | COMPANY | NATIVE (vendor client) | NATIVE (vendor Linux client) | UNKNOWN | Do not migrate | MEDIUM | Palo Alto client exists cross-platform; still corp-provisioned |
| Splashtop On-Prem | remote support | COMPANY | NATIVE (vendor client) | UNKNOWN (On-Prem specifics unverified) | UNKNOWN | Do not migrate | LOW | Corp-deployed; never transfer config |
| Central de Software | software portal | COMPANY | UNKNOWN (internal portal) | UNKNOWN | UNKNOWN | Do not migrate | LOW | Old-employer portal; ignore |
| Setup Checklist | onboarding | COMPANY | UNKNOWN (internal tooling) | UNKNOWN | UNKNOWN | Do not migrate | LOW | Old-employer onboarding; ignore |
| Setup Manager (×2 locations) | onboarding | COMPANY | UNKNOWN (internal tooling) | UNKNOWN | UNKNOWN | Do not migrate | LOW | Same install in App + Utilities; ignore |
| IBM Aspera Connect / Crypt / Launcher | corp file transfer | COMPANY | NATIVE (vendor builds) | NATIVE (IBM Linux builds/CLI) | UNKNOWN | Do not migrate | MEDIUM | Vendor has Linux builds; still corp-provisioned |

## Summaries

### Best cross-platform (vendor-supported on all three, or distro-packaged on Arch)

VS Code (Arch extra on Omarchy), DBeaver (Arch extra), Obsidian
(Arch extra; official `.deb`/AppImage on Debian), Blender, OBS,
Shutter Encoder (Debian `.deb`; AUR on Omarchy), OpenCode (install
script), Chrome and Dropbox (vendor `.deb` on Debian; AUR community
on Omarchy — packaging, not vendor support), LocalSend (upstream
builds; AUR on Omarchy).

### Windows-preferred (live on Dell host)

VS Code, Windows Terminal, DBeaver, Obsidian, Chrome, Docker Desktop
(if approved), Fork/GitHub Desktop (if kept), Adobe suite, Resolve,
Cavalry, Insta360, DJI Studio, Affinity, Wacom/Logi/Contour/DisplayLink
vendor GUIs, Office/Teams/Edge (employer-provided).

### Linux-friendly (Debian and/or Omarchy, non-bootstrap)

Shutter Encoder, Blender, OBS, LocalSend, Obsidian, DBeaver, VS Code,
AnyDesk, GitHub Desktop (shiftkey fork — unofficial), WhatsApp
(web/wrappers), Solaar, libwacom stack, displaylink-debian/AUR,
Remmina/FreeRDP, Abraunegg OneDrive (CLI-only).

### macOS-only replacements (no clone needed)

iTerm2 → Windows Terminal / Foot · Raycast → PowerToys Run /
Omarchy Menu · Rectangle → FancyZones / Hyprland tiling · AltTab →
native · BetterDisplay → OS display settings / Hyprland config ·
Dropover → drop · Keka → 7-Zip / p7zip.

### Corporate-only (do not migrate)

JamfProtect, Kaspersky, GlobalProtect, Splashtop On-Prem, Central de
Software, Setup Checklist/Manager, IBM Aspera ×3, Teams, Office ×4,
OneDrive-corp, Edge-managed, VNC Viewer, AnyDesk (corp use).

### Media compatibility gaps (weak or absent Linux parity)

Adobe Premiere/Media Encoder (none) · Affinity (Wine-only) ·
Cavalry (none) · Insta360 Studio (none) · DJI Studio (none) ·
DaVinci Resolve (unofficial-compat only + codec/GPU caveats) ·
Blackmagic satellite utilities (UNKNOWN — verify per install).

## References (official sources consulted)

- Omarchy: omarchy.org manual (Arch base, Hyprland; Foot default
  terminal with Alacritty/Ghostty/Kitty as supported options; Omarchy
  Menu launcher on Super+Space; tmux-first workflow; ships Obsidian,
  Chromium, OBS, Neovim); DistroWatch Omarchy entry; AUR RPC
  (verified: cursor-bin, github-desktop-bin,
  microsoft-edge-stable-bin, google-chrome, dropbox, anydesk-bin,
  displaylink, shutter-encoder-bin, localsend, realvnc-vnc-viewer —
  the last flagged out-of-date upstream).
- Obsidian: obsidian.md/download (official AppImage, Snap, and `.deb`
  for Linux; Flatpak explicitly labeled community-maintained) +
  Arch `extra/obsidian` package page (official repo, not AUR).
- Blackmagic: tech specs (Rocky Linux 8.6 only supported OS);
  davinciresolveclub.com 21.0.4 readme analysis; linuxjunkies.org
  install guide (deps, X11 vs Wayland, codec notes).
- Cavalry: cavalry.studio docs (Mac + Windows only; now Canva).
- Shutter Encoder: shutterencoder.com (Win/Mac/Linux, `.deb` +
  AppImage, AUR) + GitHub paulpacifico/shutter-encoder.
- Insta360: onlinemanual.insta360.com compat table (Win 10/11, macOS
  13+; no ARM; no Linux) + community Wine question.
- DJI: dji.com DJI Studio download page + FAQ (Win 10+, macOS 11+).
- Affinity: affinity.studio (Win+Mac, free unified app) +
  AffinityOnLinux (Wine method, no OpenCL/sign-in) + omgubuntu
  AppImage report.
- Contour: contourdesign.com drivers (Win+Mac only) + shuttle-go /
  OpenContourShuttle (community Linux).
- DisplayLink: synaptics.com Ubuntu driver (Ubuntu-only) +
  AdnanHodzic/displaylink-debian + Debian evdi-dkms + ArchWiki.
- Fork: fork.dev (Mac + Windows, $59.99).
- GitHub Desktop: desktop.github.com (Win+Mac official) +
  shiftkey/desktop fork (`.deb`/APT/Flatpak, community) +
  desktop/desktop#21085 (no official Linux).
- AnyDesk: anydesk.com Linux downloads (`.deb`/rpm/tar.gz + APT repo).
- WhatsApp: whatsapp.com/download (Android/iOS/Mac/Windows only) +
  ArchWiki (Web official on Linux; wrappers community) + Whatsie
  (Flathub) + snap wrappers.
- OneDrive: learn.microsoft.com (no official Linux client) +
  abraunegg/onedrive (community CLI, no Files-On-Demand).
