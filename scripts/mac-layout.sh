#!/bin/bash
# =============================================================================
# MaclinOS Live Desktop Transformer
# =============================================================================
# Transforms the running KDE Plasma desktop into the macOS layout:
#   1. Moves the panel to the TOP and styles it as the macOS Menubar
#   2. Adds the Global Menu (AppMenu) to the top bar
#   3. Sets the MaclinOS vector wallpaper
#   4. Moves window buttons to top-left (Traffic Lights: Close, Minimize, Maximize)
#   5. Applies the MaclinOS light/dark color scheme
#   6. Launches the Plank dock at the bottom
# =============================================================================

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

export DISPLAY="${DISPLAY:-:1}"

echo "========================================="
echo "  Applying MaclinOS Desktop Layout (Display $DISPLAY)..."
echo "========================================="

# Connect to user DBus session
if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ] || [[ "${DBUS_SESSION_BUS_ADDRESS:-}" != *"unix:"* ]]; then
    PLASMA_PID=$(pgrep -u "$USER" -x plasmashell 2>/dev/null | head -n1 || true)
    if [ -n "$PLASMA_PID" ] && [ -r "/proc/$PLASMA_PID/environ" ]; then
        ADDR=$(grep -z '^DBUS_SESSION_BUS_ADDRESS=' "/proc/$PLASMA_PID/environ" 2>/dev/null | cut -d= -f2- | tr -d '\0' || true)
        if [ -n "$ADDR" ]; then
            export DBUS_SESSION_BUS_ADDRESS="$ADDR"
        fi
    fi
fi

# Ensure wallpapers & themes are in ~/.local/share
mkdir -p "$HOME/.local/share/color-schemes"
mkdir -p "$HOME/.local/share/wallpapers/MaclinOS/contents/images"
mkdir -p "$HOME/.local/share/aurorae/themes/MaclinOS"

cp "$PROJECT_DIR/plasma/color-schemes/"*.colors "$HOME/.local/share/color-schemes/" 2>/dev/null || true
cp "$PROJECT_DIR/design/wallpapers/"* "$HOME/.local/share/wallpapers/MaclinOS/contents/images/" 2>/dev/null || true
cp "$PROJECT_DIR/plasma/window-decorations/MaclinOS/"* "$HOME/.local/share/aurorae/themes/MaclinOS/" 2>/dev/null || true

# Config writer helper (supports KDE 5 and KDE 6)
write_cfg() {
    local file="$1" group="$2" key="$3" value="$4"
    if command -v kwriteconfig5 >/dev/null 2>&1; then
        kwriteconfig5 --file "$file" --group "$group" --key "$key" "$value"
    elif command -v kwriteconfig6 >/dev/null 2>&1; then
        kwriteconfig6 --file "$file" --group "$group" --key "$key" "$value"
    elif command -v kwriteconfig >/dev/null 2>&1; then
        kwriteconfig --file "$file" --group "$group" --key "$key" "$value"
    fi
}

echo "[1/4] Applying macOS window buttons and colors..."
write_cfg kwinrc org.kde.kdecoration2 ButtonsOnLeft "XIA"
write_cfg kwinrc org.kde.kdecoration2 ButtonsOnRight ""
write_cfg kwinrc org.kde.kdecoration2 library "org.kde.kwin.aurorae"
write_cfg kwinrc org.kde.kdecoration2 theme "__aurorae__svg__MaclinOS"
write_cfg kwinrc Windows Placement "Centered"
write_cfg kdeglobals General ColorScheme "MaclinOS"

# Reconfigure KWin
qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true

echo "[2/4] Moving panel to TOP and setting Global Menu..."
WP_PATH="$HOME/.local/share/wallpapers/MaclinOS/contents/images/maclinos-flow-light.svg"

JS_SCRIPT="
var p = panels();
if (p.length > 0) {
    var topPanel = p[0];
    topPanel.location = 'top';
    topPanel.height = 28;
    
    // Remove the wide task manager from the top bar
    var w = topPanel.widgets();
    for (var i = 0; i < w.length; i++) {
        if (w[i].type === 'org.kde.plasma.taskmanager' || w[i].type === 'org.kde.plasma.icontasks') {
            w[i].remove();
        }
    }
    // Add Global Menu (File, Edit, View...)
    topPanel.addWidget('org.kde.plasma.appmenu');
}

// Set Wallpaper
var d = desktops();
for (var j = 0; j < d.length; j++) {
    d[j].wallpaperPlugin = 'org.kde.image';
    d[j].currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
    d[j].writeConfig('Image', 'file://${WP_PATH}');
}
"

qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$JS_SCRIPT" 2>/dev/null || \
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$JS_SCRIPT" 2>/dev/null || true

echo "[3/4] Setting wallpaper directly in config fallback..."
if [ -f "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" ]; then
    sed -i "s|Image=.*|Image=file://${WP_PATH}|g" "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" 2>/dev/null || true
fi

echo "[4/4] Starting Plank dock at bottom..."
killall plank 2>/dev/null || true
sleep 1
nohup plank >/dev/null 2>&1 &

echo "========================================="
echo "  ✅ Done! Check your browser tab now."
echo "========================================="
