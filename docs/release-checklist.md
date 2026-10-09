# MaclinOS Release Checklist

## Pre-Release (Before building release ISO)

### License Audit
- [ ] All icons are original work (not derived from Apple)
- [ ] All wallpapers are original work or CC-licensed
- [ ] Font licenses verified (OFL for Inter, JetBrains Mono)
- [ ] No Apple trademarks in any asset, string, or metadata
- [ ] Third-party theme components have compatible licenses
- [ ] Firmware included only if redistributable
- [ ] LICENSES.md is complete and accurate
- [ ] Source attribution file is up to date

### Code Quality
- [ ] All custom QML/Qt code compiles without warnings
- [ ] KWin scripts load without errors
- [ ] Plasma theme validates with plasmoidviewer
- [ ] No hardcoded paths to developer home directory
- [ ] All configs use `/etc/skel` or `/etc/xdg` for defaults
- [ ] Git repository is clean, tagged with version

### Package Build
- [ ] All .deb packages build in clean chroot
- [ ] Package dependencies are correct and complete
- [ ] Packages install cleanly on stock Debian Trixie
- [ ] Packages can be upgraded from previous version
- [ ] Packages can be cleanly removed

---

## Build Phase

### ISO Build
- [ ] live-build config is version-controlled
- [ ] Build runs in clean environment (not developer's daily machine)
- [ ] Debian mirror is pinned or checksummed
- [ ] Build completes without errors
- [ ] ISO filename includes version and date
- [ ] SHA256 checksum generated
- [ ] Package manifest generated and saved
- [ ] Build log saved

### Boot Testing
- [ ] ISO boots in QEMU/KVM (UEFI mode)
- [ ] ISO boots in VirtualBox (UEFI mode)
- [ ] Live session reaches desktop
- [ ] Desktop shows correct theme (top bar, dock, wallpaper, decorations)
- [ ] Clock, tray icons, and battery indicator display correctly
- [ ] Dock launches applications
- [ ] File manager opens
- [ ] Terminal opens
- [ ] Browser opens and loads a webpage

---

## Installation Testing

### Installer
- [ ] Installer launches from live session
- [ ] Language and keyboard selection works
- [ ] Timezone selection works
- [ ] Disk partitioning works (whole disk)
- [ ] User creation with password works
- [ ] Installation completes without errors
- [ ] System reboots into installed OS (not USB)

### Post-Install
- [ ] GRUB shows MaclinOS branding
- [ ] Plymouth boot splash displays
- [ ] SDDM login screen shows MaclinOS theme
- [ ] Login with created user succeeds
- [ ] Desktop loads with correct theme
- [ ] All panel widgets functional
- [ ] Sound works (test with browser or media player)

---

## Functionality Testing

### Desktop Shell
- [ ] Top bar: app menu/title, clock, tray visible
- [ ] Dock: pinned apps present, click launches app
- [ ] Dock: running indicator appears for running apps
- [ ] Dock: auto-hide works (if enabled)
- [ ] Window decorations: traffic light buttons work
- [ ] Window: move, resize, minimize, maximize, close
- [ ] Overview: keyboard shortcut activates
- [ ] Virtual desktops: switch and move windows
- [ ] Hot corners: configured and functional
- [ ] Right-click desktop: context menu styled

### Applications
- [ ] Dolphin: opens, browses files, correct theme
- [ ] Konsole: opens, accepts commands
- [ ] Firefox: opens, loads websites, video plays
- [ ] System Settings: opens, all pages navigable
- [ ] Text editor: opens and edits files
- [ ] Image viewer: opens images

### System Integration
- [ ] Wi-Fi: scan, connect, saved networks
- [ ] Ethernet: DHCP works
- [ ] Audio: output device detected, volume control works
- [ ] Bluetooth: scan, pair (if hardware available)
- [ ] USB: mount external drive
- [ ] Printing: CUPS reachable (printer hardware optional)
- [ ] Screenshots: keyboard shortcut captures screen

### Updates & Recovery
- [ ] `apt update` succeeds
- [ ] `apt upgrade` completes without breaking theme
- [ ] TTY login works (Ctrl+Alt+F2)
- [ ] Theme can be reset via command line
- [ ] SDDM restarts cleanly after `systemctl restart sddm`
- [ ] System recovers from killed KWin (restarts compositor)

### Accessibility
- [ ] Keyboard navigation: Tab through UI elements
- [ ] Screen reader: Orca launches and reads UI
- [ ] High contrast: toggle and verify readability
- [ ] Reduced motion: animations respect setting
- [ ] Font scaling: increase system font size
- [ ] Color scheme: light and dark mode toggle

---

## Release Artifacts

- [ ] `maclinos-{version}-amd64.iso` — bootable ISO image
- [ ] `maclinos-{version}-amd64.iso.sha256` — checksum file
- [ ] `maclinos-{version}-manifest.txt` — installed package list
- [ ] `maclinos-{version}-release-notes.md` — release notes
- [ ] `maclinos-{version}-known-issues.md` — known issues
- [ ] Source code tagged in Git (`v{version}`)

---

## Post-Release

- [ ] Upload ISO and checksums to release server
- [ ] Update project website/README with download links
- [ ] Announce release with changelog
- [ ] Monitor initial bug reports
- [ ] Plan next release milestones
