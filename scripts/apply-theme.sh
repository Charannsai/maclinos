#!/bin/bash
# =============================================================================
# MaclinOS Theme Applier
# =============================================================================
# Applies the MaclinOS theme to the current KDE Plasma session.
# This installs color schemes, window decorations, panel layout, and defaults.
#
# Usage: chmod +x scripts/apply-theme.sh && ./scripts/apply-theme.sh
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================="
echo "  MaclinOS Theme Applier"
echo "========================================="

# --- Verify KDE Plasma is running ---
if ! pgrep -x plasmashell >/dev/null 2>&1; then
    echo "ERROR: KDE Plasma shell is not running."
    echo "       This script must be run in an active Plasma session."
    exit 1
fi

# --- Paths ---
PLASMA_DIR="$PROJECT_DIR/plasma"
LOCAL_SHARE="$HOME/.local/share"
CONFIG_DIR="$HOME/.config"

# --- Install Color Schemes ---
echo "[1/7] Installing color schemes..."
mkdir -p "$LOCAL_SHARE/color-schemes"
cp "$PLASMA_DIR/color-schemes/MaclinOS.colors" "$LOCAL_SHARE/color-schemes/"
cp "$PLASMA_DIR/color-schemes/MaclinOSDark.colors" "$LOCAL_SHARE/color-schemes/"
echo "  ✓ MaclinOS (Light) and MaclinOS Dark installed"

# --- Install Window Decoration ---
echo "[2/7] Installing window decorations..."
mkdir -p "$LOCAL_SHARE/aurorae/themes/MaclinOS"
cp "$PLASMA_DIR/window-decorations/MaclinOS/"* "$LOCAL_SHARE/aurorae/themes/MaclinOS/"
echo "  ✓ MaclinOS window decoration installed"

# --- Install Global Theme ---
echo "[3/7] Installing global theme..."
mkdir -p "$LOCAL_SHARE/plasma/look-and-feel/MaclinOS/contents"
cp "$PLASMA_DIR/global-theme/metadata.desktop" "$LOCAL_SHARE/plasma/look-and-feel/MaclinOS/"
cp -r "$PLASMA_DIR/global-theme/contents/"* "$LOCAL_SHARE/plasma/look-and-feel/MaclinOS/contents/" 2>/dev/null || true
echo "  ✓ MaclinOS global theme installed"

# --- Install SDDM Theme (requires sudo) ---
echo "[4/7] Installing SDDM theme..."
if [ -d "/usr/share/sddm/themes" ]; then
    sudo mkdir -p "/usr/share/sddm/themes/MaclinOS"
    sudo cp "$PLASMA_DIR/sddm/MaclinOS/"* "/usr/share/sddm/themes/MaclinOS/"
    echo "  ✓ MaclinOS SDDM theme installed"
    echo "  NOTE: To activate, set theme in /etc/sddm.conf or via System Settings"
else
    echo "  ⚠ SDDM not found; skipping SDDM theme"
fi

# --- Install Wallpapers ---
echo "[5/7] Installing wallpapers..."
WALLPAPER_DIR="$LOCAL_SHARE/wallpapers/MaclinOS"
mkdir -p "$WALLPAPER_DIR/contents/images"
if [ -d "$PROJECT_DIR/design/wallpapers" ] && [ "$(ls -A "$PROJECT_DIR/design/wallpapers" 2>/dev/null)" ]; then
    cp "$PROJECT_DIR/design/wallpapers/"* "$WALLPAPER_DIR/contents/images/" 2>/dev/null || true
    echo "  ✓ Wallpapers installed"
else
    echo "  ⚠ No wallpapers found in design/wallpapers/; skipping"
fi

# --- Apply KDE Settings ---
echo "[6/7] Applying KDE configuration..."

# Color scheme
kwriteconfig6 --file kdeglobals --group General --key ColorScheme "MaclinOS"

# Window decoration: left-side traffic light buttons
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft "XIA"
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight ""
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key BorderSize "None"

# Window behavior
kwriteconfig6 --file kwinrc --group Windows --key Placement "Centered"
kwriteconfig6 --file kwinrc --group Compositing --key AnimationSpeed "3"

# KWin effects
kwriteconfig6 --file kwinrc --group Plugins --key blurEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key contrastEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key overviewEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key slideEnabled "true"
kwriteconfig6 --file kwinrc --group Plugins --key magiclampEnabled "true"

# Overview hot corner (top-left)
kwriteconfig6 --file kwinrc --group Effect-overview --key BorderActivate "9"

# Fonts
kwriteconfig6 --file kdeglobals --group General --key font "Inter,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key fixed "JetBrains Mono,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key smallestReadableFont "Inter,8,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key toolBarFont "Inter,9,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key menuFont "Inter,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group WM --key activeFont "Inter,10,-1,5,50,0,0,0,0,0"

# Click-to-focus (macOS-like)
kwriteconfig6 --file kwinrc --group Windows --key FocusPolicy "ClickToFocus"

echo "  ✓ KDE settings applied"

# --- Reload ---
echo "[7/7] Reloading Plasma shell and KWin..."
qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true

echo ""
echo "========================================="
echo "  ✅ MaclinOS theme applied!"
echo "========================================="
echo ""
echo "Some changes may require logging out and back in."
echo "Panel layout changes may need manual adjustment in Plasma settings."
echo ""
echo "To revert, use System Settings → Appearance → Global Theme → Breeze"
echo ""
