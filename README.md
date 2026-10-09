# MaclinOS

**A macOS-inspired Linux desktop experience, built on Debian and KDE Plasma.**

![License](https://img.shields.io/badge/license-GPL--3.0-blue)
![Base](https://img.shields.io/badge/base-Debian%2013%20Trixie-red)
![Desktop](https://img.shields.io/badge/desktop-KDE%20Plasma%206-green)
![Architecture](https://img.shields.io/badge/arch-amd64-lightgrey)

---

## What is MaclinOS?

MaclinOS preserves a fully functional Linux operating system while replacing the visible desktop aesthetic and interaction patterns with a cohesive macOS-inspired experience. It is **not** macOS — it runs the Linux kernel, uses `apt`, `systemd`, and standard Linux applications.

### What's included

- 🎨 Original design system with light/dark palettes, custom icons, and wallpapers
- 🖥️ Top menu bar with app title, clock, system tray, and connectivity indicators
- ⚓ Floating bottom dock with pinned apps, running indicators, and auto-hide
- 🚀 Spotlight-style application launcher
- 🪟 macOS-inspired window decorations and controls (traffic lights)
- 🌊 KWin animations, overview, virtual desktops, and hot corners
- 📁 Themed Dolphin file manager
- 🔐 Branded SDDM login and lock screens
- 🖼️ Custom boot splash and wallpapers
- 📦 Bootable Debian-based ISO with installer

### What's NOT included

- ❌ Apple proprietary apps (Finder, Safari, iMessage, FaceTime)
- ❌ macOS binary compatibility
- ❌ Apple ecosystem features (AirDrop, Handoff, etc.)
- ❌ Redistributed Apple assets or trademarks

---

## Quick Start

### Prerequisites

- Debian 13 (Trixie) VM or machine (amd64)
- 4 GB RAM minimum, 8 GB recommended
- 20 GB disk space minimum

### Development Setup

```bash
# Clone the repository
git clone https://github.com/your-org/maclinos.git
cd maclinos

# Run the development environment setup
chmod +x scripts/setup-dev.sh
./scripts/setup-dev.sh

# Apply the theme to your current KDE Plasma session
chmod +x scripts/apply-theme.sh
./scripts/apply-theme.sh
```

### Build the ISO

```bash
# Build a bootable ISO (requires root, run in build VM)
chmod +x scripts/build-iso.sh
sudo ./scripts/build-iso.sh
```

---

## Repository Structure

```
maclinos/
├── README.md                    # This file
├── LICENSES.md                  # License inventory and attribution
├── docs/                        # Project documentation
│   ├── product-scope.md         # Product scope and non-goals
│   ├── design-system.md         # Design tokens and specifications
│   ├── architecture.md          # Technical architecture
│   ├── hardware-matrix.md       # Supported hardware
│   └── release-checklist.md     # Release process checklist
├── design/                      # Design assets
│   ├── icons/                   # Original icon set
│   ├── wallpapers/              # Original wallpapers
│   ├── cursors/                 # Custom cursor theme
│   └── tokens/                  # Design tokens (JSON/CSS)
├── plasma/                      # KDE Plasma customization
│   ├── global-theme/            # Plasma Global Theme package
│   ├── color-schemes/           # Color scheme files
│   ├── desktoptheme/            # Plasma desktop theme (SVG)
│   ├── window-decorations/      # Aurorae window decorations
│   ├── widgets/                 # Custom Plasmoids (QML)
│   ├── kwin-scripts/            # KWin scripts and effects
│   ├── layout/                  # Panel and desktop layout
│   └── sddm/                   # SDDM login theme
├── packages/                    # Debian packages
│   ├── maclinos-theme/          # Theme metapackage
│   ├── maclinos-defaults/       # Default settings (/etc/skel)
│   └── maclinos-launcher/       # Custom launcher app
├── image/                       # ISO build configuration
│   ├── auto/                    # live-build auto scripts
│   ├── config/                  # live-build config
│   │   ├── package-lists/       # Package lists
│   │   ├── includes.chroot/     # Files included in rootfs
│   │   └── hooks/               # Build hooks
│   └── installer/               # Installer branding
├── scripts/                     # Build and utility scripts
│   ├── setup-dev.sh             # Development environment setup
│   ├── apply-theme.sh           # Apply theme to current session
│   ├── build-iso.sh             # Build bootable ISO
│   ├── smoke-test.sh            # Automated smoke tests
│   └── collect-manifest.sh      # Package manifest generator
├── tests/                       # Test suites
│   ├── vm/                      # VM-based tests
│   ├── hardware/                # Hardware test scripts
│   └── accessibility/           # Accessibility tests
└── .github/workflows/           # CI/CD pipelines
    ├── build-theme.yml          # Theme build and lint
    ├── build-iso.yml            # ISO build pipeline
    └── smoke-test.yml           # Post-build smoke tests
```

---

## Phases

| Phase | Description | Status |
|-------|-------------|--------|
| A0 | Development environment | 🔲 Not started |
| A1 | Visual design system | 🔲 Not started |
| A2 | Plasma customization | 🔲 Not started |
| A3 | Custom development | 🔲 Not started |
| C0 | Reproducible build design | 🔲 Not started |
| C1 | Live ISO | 🔲 Not started |
| C2 | Installation & updates | 🔲 Not started |
| C3 | Hardware & release QA | 🔲 Not started |

---

## Contributing

See [docs/contributing.md](docs/contributing.md) for guidelines.

## License

This project is licensed under GPL-3.0. See [LICENSES.md](LICENSES.md) for full details.

Original artwork and design assets are licensed under CC-BY-SA-4.0 unless noted otherwise.
