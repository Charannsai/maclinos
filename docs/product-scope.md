# MaclinOS Product Scope

## Vision

Preserve a conventional, fully functional Linux operating system while replacing
the entire visible desktop aesthetic and primary interaction patterns with a
cohesive macOS-inspired experience.

## Strategy

- **Option A** (KDE Plasma customization): Validate the UX on an existing Debian + Plasma install
- **Option C** (Custom Debian distribution): Ship it as a bootable, installable ISO

## In Scope

| Category | Components |
|----------|------------|
| Desktop shell | Top bar, dock, application launcher, system tray |
| Window management | Decorations, controls, overview, virtual desktops |
| Theming | Colors, typography, icons, cursors, wallpapers |
| Notifications | Notification center, do-not-disturb, grouping |
| Quick settings | Wi-Fi, audio, brightness, Bluetooth toggles |
| Authentication | Login screen (SDDM), lock screen |
| Boot | Boot splash (Plymouth), GRUB branding |
| Input | Keyboard shortcuts, touchpad gestures, hot corners |
| File management | Dolphin theming with consistent look |
| Application defaults | Browser, terminal, text editor, image viewer |
| Distribution | Installer branding, bootable ISO, update mechanism |
| Recovery | Rescue mode, theme reset, display manager recovery |

## Preserved (Linux Foundation)

| Component | Technology |
|-----------|------------|
| Kernel | Linux (Debian-packaged) |
| Init | systemd |
| Package management | apt / dpkg |
| Filesystem | Standard Linux FHS |
| Permissions | Unix permissions, PolicyKit |
| Networking | NetworkManager |
| Audio | PipeWire |
| Display | Wayland (KWin) |
| Printing | CUPS |
| Bluetooth | BlueZ |
| Accessibility | AT-SPI, Orca |
| Terminal | Standard bash/zsh with full functionality |

## Non-Goals

1. **No macOS binaries**: We do not run or emulate macOS applications
2. **No Apple apps**: No Finder, Safari, iMessage, FaceTime, etc.
3. **No Apple ecosystem**: No AirDrop, Handoff, Continuity, iCloud
4. **No pixel-perfect parity**: GTK apps, Electron apps, and some third-party
   apps will have visual inconsistencies — this is documented, not hidden
5. **No guaranteed gestures**: Touchpad gesture quality depends on hardware
   and libinput support
6. **No Apple assets**: All visual elements are independently created

## Success Criteria for v0.1

A user can:
1. Download a signed, checksummed ISO image
2. Boot it on UEFI hardware or VM
3. Install it to disk with user creation
4. Log into an attractive macOS-inspired desktop
5. Use browser, file manager, terminal, and settings
6. Connect to Wi-Fi and configure audio
7. Install software via apt and optionally Flatpak
8. Update safely without breaking the desktop
9. Recover from a broken theme via TTY or rescue mode

The OS remains Linux underneath at all times.
