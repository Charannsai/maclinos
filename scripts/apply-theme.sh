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

# --- Check if KDE Plasma is running ---
PLASMA_RUNNING=0
if pgrep -x plasmashell >/dev/null 2>&1; then
    PLASMA_RUNNING=1
    echo "  Active Plasma session detected."
else
    echo "  ℹ️ Note: Plasma shell is not running yet."
    echo "  Theme assets and configs will be installed for next session startup."
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

# Helper to write KDE config using kwriteconfig6 or kwriteconfig5
write_kconfig() {
    local file="$1" group="$2" key="$3" value="$4"
    if command -v kwriteconfig6 >/dev/null 2>&1; then
        kwriteconfig6 --file "$file" --group "$group" --key "$key" "$value"
    elif command -v kwriteconfig5 >/dev/null 2>&1; then
        kwriteconfig5 --file "$file" --group "$group" --key "$key" "$value"
    fi
}

# --- Apply KDE Settings ---
echo "[6/7] Applying KDE configuration..."

# Color scheme
write_kconfig kdeglobals General ColorScheme "MaclinOS"

# Window decoration: left-side traffic light buttons
write_kconfig kwinrc org.kde.kdecoration2 ButtonsOnLeft "XIA"
write_kconfig kwinrc org.kde.kdecoration2 ButtonsOnRight ""
write_kconfig kwinrc org.kde.kdecoration2 BorderSize "None"

# Window behavior
write_kconfig kwinrc Windows Placement "Centered"
write_kconfig kwinrc Compositing AnimationSpeed "3"

# KWin effects
write_kconfig kwinrc Plugins blurEnabled "true"
write_kconfig kwinrc Plugins contrastEnabled "true"
write_kconfig kwinrc Plugins overviewEnabled "true"
write_kconfig kwinrc Plugins slideEnabled "true"
write_kconfig kwinrc Plugins magiclampEnabled "true"

# Overview hot corner (top-left)
write_kconfig kwinrc Effect-overview BorderActivate "9"

# Fonts
write_kconfig kdeglobals General font "Inter,10,-1,5,50,0,0,0,0,0"
write_kconfig kdeglobals General fixed "JetBrains Mono,10,-1,5,50,0,0,0,0,0"
write_kconfig kdeglobals General smallestReadableFont "Inter,8,-1,5,50,0,0,0,0,0"
write_kconfig kdeglobals General toolBarFont "Inter,9,-1,5,50,0,0,0,0,0"
write_kconfig kdeglobals General menuFont "Inter,10,-1,5,50,0,0,0,0,0"
write_kconfig kdeglobals WM activeFont "Inter,10,-1,5,50,0,0,0,0,0"

# Click-to-focus (macOS-like)
write_kconfig kwinrc Windows FocusPolicy "ClickToFocus"

echo "  ✓ KDE settings applied"

# --- Reload ---
if [ "$PLASMA_RUNNING" -eq 1 ]; then
    echo "[7/7] Reloading Plasma shell and KWin..."
    qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
else
    echo "[7/7] Skipping reload (Plasma is not running; changes will take effect when started)."
fi

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
