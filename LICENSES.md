# MaclinOS License Inventory

This document tracks all licenses for code, assets, and third-party dependencies
used in the MaclinOS distribution.

---

## Project Code

| Component | License | Notes |
|-----------|---------|-------|
| MaclinOS scripts and tools | GPL-3.0-or-later | Original code |
| Plasma Global Theme | GPL-3.0-or-later | Original theme package |
| KWin scripts | GPL-3.0-or-later | Original scripts |
| Custom Plasmoids | GPL-3.0-or-later | Original QML widgets |
| Custom Launcher | GPL-3.0-or-later | Original Qt/QML application |

## Design Assets

| Asset | License | Notes |
|-------|---------|-------|
| MaclinOS icons | CC-BY-SA-4.0 | Original artwork, not derived from Apple |
| MaclinOS wallpapers | CC-BY-SA-4.0 | Original artwork |
| MaclinOS cursors | CC-BY-SA-4.0 | Original cursor theme |
| Design tokens | CC-BY-SA-4.0 | Original color/spacing system |

## Fonts

| Font | License | Source |
|------|---------|--------|
| Inter | OFL-1.1 | https://rsms.me/inter/ |
| SF Mono alternative (JetBrains Mono) | OFL-1.1 | https://www.jetbrains.com/lp/mono/ |

## Third-Party Dependencies

| Package | License | Usage |
|---------|---------|-------|
| KDE Plasma | GPL-2.0+/LGPL-2.1+ | Desktop environment |
| KWin | GPL-2.0+ | Window manager/compositor |
| Qt 6 | LGPL-3.0/GPL-3.0 | UI framework |
| SDDM | GPL-2.0+ | Display manager |
| Dolphin | GPL-2.0+ | File manager |
| PipeWire | MIT/LGPL-2.1+ | Audio system |
| NetworkManager | GPL-2.0+ | Network management |
| systemd | LGPL-2.1+ | Init system |
| Linux kernel | GPL-2.0 | Kernel |
| Debian packages | Various (GPL, MIT, BSD) | Base system |

## Firmware

| Firmware | License | Notes |
|----------|---------|-------|
| linux-firmware | Various (redistributable) | Only include redistributable firmware |
| intel-microcode | Proprietary (redistributable) | CPU microcode updates |
| amd64-microcode | Proprietary (redistributable) | CPU microcode updates |

---

## Legal Boundaries

1. **No Apple assets**: All icons, wallpapers, sounds, and branding are original works
2. **No Apple trademarks**: The name "MaclinOS" does not claim affiliation with Apple
3. **No macOS binaries**: No Apple software is included or emulated
4. **Font compliance**: Only OFL/SIL or similarly licensed fonts are used
5. **Firmware review**: Each firmware blob's license is verified before inclusion

## Attribution

This project is inspired by the visual design language of macOS but contains
no Apple-owned code, assets, or intellectual property. All visual elements
are independently created original works.

---

*Last updated: 2026-10-09*
*Review required before each release*
