# MaclinOS Contributing Guide

Thank you for your interest in contributing to MaclinOS!

## Getting Started

1. **Fork and clone** the repository
2. **Set up** a Debian 13 (Trixie) VM — never develop on your daily machine
3. **Run** `./scripts/setup-dev.sh` to install development tools
4. **Take a VM snapshot** before making changes

## What You Can Contribute

### Design
- Original icon designs (SVG format, not derived from Apple assets)
- Original wallpaper artwork (minimum 3840×2160)
- Cursor theme designs
- UI/UX mockups and feedback

### Plasma Theming
- Color scheme refinements
- Desktop theme SVG improvements
- Window decoration enhancements
- SDDM login theme improvements
- Plasma widget/panel layout improvements

### Custom Widgets
- QML-based Plasmoids for gaps in the UX
- KWin scripts for effects and behaviors
- Custom launcher improvements

### Documentation
- Hardware testing reports
- Bug reports and fix documentation
- User guides and tutorials
- Translation / localization

### Testing
- VM installation testing
- Hardware compatibility reports
- Accessibility testing
- Upgrade/update testing

## Code Standards

- **Shell scripts**: Use `set -euo pipefail`, POSIX-compatible when possible
- **QML**: Follow KDE QML coding conventions
- **SVG**: Optimized, clean SVG without embedded raster data
- **No Apple assets**: All contributions must be original or compatibly licensed
- **Paths**: Use `/etc/skel` or `/etc/xdg` for defaults; never hardcode home directories

## Pull Request Process

1. Create a feature branch from `main`
2. Make your changes with descriptive commits
3. Test in a clean Debian VM
4. Run `./scripts/smoke-test.sh` if applicable
5. Submit a PR with description of changes and testing done

## Legal

By contributing, you agree that your contributions are licensed under:
- **Code**: GPL-3.0-or-later
- **Artwork/Design**: CC-BY-SA-4.0

All contributions must be original work or have compatible licensing.
No Apple-owned assets, trademarks, or derived works may be included.
