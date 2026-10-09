# MaclinOS Architecture

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    MaclinOS Desktop Experience                   │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌───────────────────┐  │
│  │ Top Bar  │ │   Dock   │ │ Launcher │ │ Notification Ctr  │  │
│  └──────────┘ └──────────┘ └──────────┘ └───────────────────┘  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌───────────────────┐  │
│  │ Overview │ │ Widgets  │ │ Settings │ │  Quick Settings   │  │
│  └──────────┘ └──────────┘ └──────────┘ └───────────────────┘  │
├─────────────────────────────────────────────────────────────────┤
│              KDE Plasma 6 Shell + KWin Compositor               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │ Plasma Shell│  │ KWin/Wayland│  │ SDDM Display Manager    │ │
│  │ (QML/C++)   │  │ (Compositor)│  │ (Login/Lock Screens)    │ │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘ │
├─────────────────────────────────────────────────────────────────┤
│                    Qt 6 / KDE Frameworks 6                      │
│           Wayland Protocol · XDG Desktop Portals                │
├─────────────────────────────────────────────────────────────────┤
│              Debian 13 (Trixie) Userspace                       │
│  ┌──────────┐ ┌───────────┐ ┌──────────┐ ┌──────────────────┐ │
│  │ systemd  │ │ PipeWire  │ │ Network  │ │    apt / dpkg    │ │
│  │          │ │ (audio)   │ │ Manager  │ │                  │ │
│  └──────────┘ └───────────┘ └──────────┘ └──────────────────┘ │
│  ┌──────────┐ ┌───────────┐ ┌──────────┐ ┌──────────────────┐ │
│  │  CUPS    │ │  BlueZ    │ │ PolicyKit│ │  Flatpak (opt)   │ │
│  └──────────┘ └───────────┘ └──────────┘ └──────────────────┘ │
├─────────────────────────────────────────────────────────────────┤
│                    Linux Kernel + Firmware                       │
│  ┌─────────┐ ┌──────────┐ ┌──────────┐ ┌───────────────────┐  │
│  │  GPU    │ │  Wi-Fi   │ │  Audio   │ │  Input Devices    │  │
│  │ Drivers │ │  Drivers │ │  Drivers │ │  (libinput)       │  │
│  └─────────┘ └──────────┘ └──────────┘ └───────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Package Architecture

### Brand Packages (custom .deb)

```
maclinos-theme              # Metapackage: depends on all theme components
├── maclinos-plasma-theme   # Plasma Global Theme (colors, style, SVGs)
├── maclinos-icons          # Icon theme (SVG/PNG)
├── maclinos-cursors        # Cursor theme
├── maclinos-wallpapers     # Wallpaper collection
├── maclinos-sddm-theme     # SDDM login screen theme
├── maclinos-plymouth       # Boot splash theme
└── maclinos-sounds         # System sounds (CC-licensed)

maclinos-defaults           # Default configuration
├── /etc/skel/.config/      # KDE/Plasma user defaults
├── /etc/skel/.local/       # Local data defaults
├── /etc/xdg/               # System-wide XDG defaults
└── /usr/share/maclinos/    # Shared resources

maclinos-launcher           # Custom application launcher (if needed)
├── Binary                  # Qt/QML application
└── .desktop entry          # Desktop integration

maclinos-kwin-scripts       # KWin scripts for effects/behaviors
└── /usr/share/kwin/scripts/
```

### Dependency Chain
```
maclinos-meta (top-level metapackage)
├── maclinos-theme
│   ├── maclinos-plasma-theme
│   ├── maclinos-icons
│   ├── maclinos-cursors
│   ├── maclinos-wallpapers
│   ├── maclinos-sddm-theme
│   └── maclinos-plymouth
├── maclinos-defaults
├── maclinos-kwin-scripts
├── maclinos-launcher (optional/recommends)
├── plasma-desktop
├── kde-standard
├── sddm
├── pipewire + wireplumber
├── network-manager
├── firefox-esr | chromium
├── dolphin
├── konsole
├── fonts-inter
└── fonts-jetbrains-mono (or similar)
```

## Build Architecture

### ISO Build Pipeline

```
┌──────────────────────────────────────────────────┐
│                  Build Server (CI)                │
│                                                   │
│  ┌────────────┐   ┌────────────────────────────┐ │
│  │ Source Repo │──>│ Package Build (dpkg-buildpkg)│ │
│  └────────────┘   └─────────────┬──────────────┘ │
│                                 │                 │
│                   ┌─────────────▼──────────────┐  │
│                   │   Local APT Repository     │  │
│                   │   (maclinos-*.deb files)   │  │
│                   └─────────────┬──────────────┘  │
│                                 │                 │
│  ┌────────────┐   ┌─────────────▼──────────────┐  │
│  │ Debian     │──>│      live-build            │  │
│  │ Mirrors    │   │  (lb config + lb build)    │  │
│  └────────────┘   └─────────────┬──────────────┘  │
│                                 │                 │
│                   ┌─────────────▼──────────────┐  │
│                   │   maclinos-0.1-amd64.iso   │  │
│                   │   + SHA256 + manifest       │  │
│                   └────────────────────────────┘  │
└──────────────────────────────────────────────────┘
```

### Configuration Hierarchy

```
System defaults (shipped in packages):
  /usr/share/maclinos/                    # Brand assets
  /usr/share/plasma/desktoptheme/MaclinOS/ # Plasma theme
  /usr/share/color-schemes/MaclinOS.colors # Color scheme
  /usr/share/icons/MaclinOS/              # Icons
  /usr/share/sddm/themes/MaclinOS/       # SDDM

System-wide settings:
  /etc/xdg/                               # XDG defaults for all users

Per-user defaults (first login):
  /etc/skel/.config/                       # Copied to ~/config/
  /etc/skel/.local/                        # Copied to ~/.local/

User overrides:
  ~/.config/                               # User customizations win
  ~/.local/                                # User local data
```

## Session Architecture

### Boot → Login → Desktop

```
BIOS/UEFI
  └── GRUB (MaclinOS branded)
       └── Linux kernel + initramfs
            └── systemd
                 ├── Multi-user.target
                 │   ├── NetworkManager
                 │   ├── PipeWire
                 │   └── system services
                 └── graphical.target
                      └── SDDM (MaclinOS theme)
                           └── User authenticates
                                └── Plasma session
                                     ├── KWin (Wayland compositor)
                                     ├── Plasma Shell (panels, dock)
                                     ├── KDE daemons
                                     └── Autostart apps
```

### Display Protocol

- **Primary**: Wayland (KWin as Wayland compositor)
- **Fallback**: X11 session available via SDDM session switcher
- **Portals**: xdg-desktop-portal-kde for file dialogs, screen sharing
- **XWayland**: Enabled for legacy X11 applications

## Security Boundaries

### What We DO NOT Modify

1. PAM authentication stack
2. PolicyKit rules (beyond standard KDE defaults)
3. Kernel parameters (beyond standard Debian)
4. systemd security units
5. User/group management
6. Sudo configuration
7. AppArmor/SELinux profiles
8. Network security configuration

### What We Customize (Cosmetic Only)

1. SDDM theme (QML visual layer; authentication handled by PAM)
2. Lock screen appearance (Plasma lock screen; security via KDE's lock mechanism)
3. Plymouth boot splash (visual only)
4. GRUB theme (visual only)

## Multi-Monitor Strategy

1. Top bar: appears on the primary display; secondary displays can optionally show a minimal bar
2. Dock: appears on the primary display; configurable to appear on all displays
3. Wallpapers: independent per display
4. Window placement: follows KDE Plasma defaults (user-configurable)
5. HiDPI: per-display scaling via KDE's built-in fractional scaling

## Technology Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Desktop Environment | KDE Plasma 6 | Most customizable mainstream DE; Qt/QML extensibility |
| Base Distribution | Debian 13 Trixie | Stability, wide hardware support, live-build tooling |
| Display Protocol | Wayland (primary) | Modern, secure, required for Plasma 6 |
| Audio | PipeWire | Modern, replaces PulseAudio/JACK |
| Display Manager | SDDM | KDE's default; QML themeable |
| File Manager | Dolphin | KDE native; deeply themeable |
| Terminal | Konsole | KDE native; profile-based theming |
| Browser | Firefox ESR | Stable, well-integrated |
| Networking | NetworkManager | Standard, applet integration |
| Boot splash | Plymouth | Standard, theme-based |
| Package format | .deb | Native to Debian |
| ISO builder | live-build | Debian's official tool |
