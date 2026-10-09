#!/bin/bash
# =============================================================================
# MaclinOS Desktop Recovery Tool
# =============================================================================
# Restores MaclinOS desktop settings to factory default.
# Safe to run from a virtual terminal (TTY: Ctrl+Alt+F3) or terminal window.
#
# Usage:
#   maclinos-recover [--force]
# =============================================================================

set -euo pipefail

BACKUP_DIR="$HOME/.config/maclinos-backup-$(date +%Y%m%d-%H%M%S)"
SKEL_DIR="/etc/skel"

echo "========================================="
echo "  MaclinOS Emergency Recovery Utility"
echo "========================================="
echo ""

if [ "${1:-}" != "--force" ]; then
    read -rp "This will reset your desktop layout and window settings to default. Proceed? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Aborted by user."
        exit 0
    fi
fi

echo "1. Creating backup of current KDE/Plasma configurations in: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
for file in kdeglobals kwinrc plasma-org.kde.plasma.desktop-appletsrc kglobalshortcutsrc; do
    if [ -f "$HOME/.config/$file" ]; then
        cp "$HOME/.config/$file" "$BACKUP_DIR/"
    fi
done

echo "2. Restoring default configurations..."
if [ -d "$SKEL_DIR/.config" ]; then
    cp -r "$SKEL_DIR/.config/"* "$HOME/.config/" 2>/dev/null || true
else
    # Fallback default configuration if /etc/skel is missing or on dev machine
    mkdir -p "$HOME/.config"
    cat > "$HOME/.config/kdeglobals" << 'EOF'
[General]
ColorScheme=MaclinOS
font=Inter,10,-1,5,50,0,0,0,0,0
fixed=JetBrains Mono,10,-1,5,50,0,0,0,0,0

[WM]
activeFont=Inter,10,-1,5,50,0,0,0,0,0
EOF

    cat > "$HOME/.config/kwinrc" << 'EOF'
[org.kde.kdecoration2]
ButtonsOnLeft=XIA
ButtonsOnRight=
BorderSize=None
BorderSizeAuto=false

[Windows]
Placement=Centered
FocusPolicy=ClickToFocus

[Plugins]
blurEnabled=true
contrastEnabled=true
EOF
fi

echo "3. Restarting Plasma desktop services if running..."
if pgrep -x plasmashell >/dev/null 2>&1; then
    kquitapp6 plasmashell 2>/dev/null || killall plasmashell 2>/dev/null || true
    kstart6 plasmashell >/dev/null 2>&1 &
fi

if pgrep -x kwin_wayland >/dev/null 2>&1; then
    echo "  KWin is managed under Wayland session; re-applying configuration..."
    qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true
fi

echo ""
echo "========================================="
echo "  ✅ MaclinOS desktop settings restored!"
echo "  Backup stored in: $BACKUP_DIR"
echo "========================================="
