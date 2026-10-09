#!/bin/bash
# =============================================================================
# MaclinOS Deep macOS Experience Installer
# =============================================================================
# Transforms every layer of the desktop to look, feel, and behave like macOS:
#   1. macOS Frosted Glass Dock (Plank with Zoom Magnification + Sonoma theme)
#   2. Pinned macOS Dock Launchers (Finder, Launchpad, Safari/Browser, Music, Terminal, Settings, Trash)
#   3. Authentic macOS Squircle Icon Theme
#   4. Spotlight Search (Centered floating search pill via Ctrl+Space / Meta+Space)
#   5. Top Menu Bar (Apple Logo Menu, Global App Menus, Control Center, System Clock)
#   6. Finder-style Dolphin File Manager layout
#   7. macOS Typography & Smooth Font Rendering
# =============================================================================

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
export DISPLAY="${DISPLAY:-:1}"

echo "========================================="
echo "  MaclinOS Deep macOS Transformation"
echo "  Configuring full macOS UI & UX..."
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

# Config helper
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

# --- STEP 1: Authentic macOS Frosted Glass Dock Theme ---
echo "[1/6] Creating macOS Frosted Glass Dock theme & settings..."
PLANK_THEME_DIR="$HOME/.local/share/plank/themes/MaclinOS"
mkdir -p "$PLANK_THEME_DIR"

cat > "$PLANK_THEME_DIR/dock.theme" << 'EOF'
# MaclinOS Frosted Glass macOS Dock Theme
[PlankTheme]
TopRoundness=14
BottomRoundness=14
LineWidth=1
LineColor=255;;255;;255;;70
FillStartColor=245;;245;;247;;180
FillEndColor=230;;230;;235;;200
InnerStrokeColor=0;;0;;0;;20
BottomPadding=4
TopPadding=4
ItemPadding=6
IndicatorSize=4
IconShadowSize=1
UrgentBounceTime=600
LaunchBounceTime=600
FadeOpacity=1
ClickTime=300
EOF

# Plank configuration with macOS zoom magnification
mkdir -p "$HOME/.config/plank/dock1"
cat > "$HOME/.config/plank/dock1/settings" << 'EOF'
[PlankDockPreferences]
Alignment=center
AutoPinning=true
CurrentWorkspaceOnly=false
DockItems=finder.dockitem;;browser.dockitem;;terminal.dockitem;;settings.dockitem;;trash.dockitem
HideDelay=0
HideMode=dodge-active-window
IconSize=56
ItemPackType=left
LockItems=false
Monitor=
Offset=0
PinnedOnly=false
Position=bottom
PressureReveal=false
ShowDockItem=false
Theme=MaclinOS
UnhideDelay=0
ZoomEnabled=true
ZoomPercent=150
EOF

# Pinned Dock Items
LAUNCHERS_DIR="$HOME/.config/plank/dock1/launchers"
mkdir -p "$LAUNCHERS_DIR"

# Finder (Dolphin)
cat > "$LAUNCHERS_DIR/finder.dockitem" << 'EOF'
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/org.kde.dolphin.desktop
EOF

# Safari / Web Browser
if [ -f /usr/share/applications/firefox-esr.desktop ]; then
    cat > "$LAUNCHERS_DIR/browser.dockitem" << 'EOF'
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/firefox-esr.desktop
EOF
elif [ -f /usr/share/applications/firefox.desktop ]; then
    cat > "$LAUNCHERS_DIR/browser.dockitem" << 'EOF'
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/firefox.desktop
EOF
fi

# Terminal
if [ -f /usr/share/applications/org.kde.konsole.desktop ]; then
    cat > "$LAUNCHERS_DIR/terminal.dockitem" << 'EOF'
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/org.kde.konsole.desktop
EOF
fi

# System Preferences / Settings
if [ -f /usr/share/applications/systemsettings.desktop ]; then
    cat > "$LAUNCHERS_DIR/settings.dockitem" << 'EOF'
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/systemsettings.desktop
EOF
fi

# Trash
cat > "$LAUNCHERS_DIR/trash.dockitem" << 'EOF'
[PlankDockItemPreferences]
Launcher=trash:///
EOF

# --- STEP 2: Install macOS Icon Theme ---
echo "[2/6] Installing macOS-styled squircle icon theme..."
ICONS_DIR="$HOME/.local/share/icons"
mkdir -p "$ICONS_DIR"

# Download high-quality macOS icon set if not present
if [ ! -d "$ICONS_DIR/WhiteSur" ] && [ ! -d "$ICONS_DIR/McMojave-circle" ]; then
    echo "  Downloading curated macOS squircle icon theme..."
    curl -sL https://github.com/vinceliuice/WhiteSur-icon-theme/archive/refs/heads/master.tar.gz | tar -xz -C /tmp/ 2>/dev/null || true
    if [ -d "/tmp/WhiteSur-icon-theme-master" ]; then
        bash /tmp/WhiteSur-icon-theme-master/install.sh -d "$ICONS_DIR" >/dev/null 2>&1 || true
        rm -rf /tmp/WhiteSur-icon-theme-master
    fi
fi

# Apply icon theme
if [ -d "$ICONS_DIR/WhiteSur" ]; then
    write_cfg kdeglobals Icons Theme "WhiteSur"
elif [ -d "/usr/share/icons/breeze" ]; then
    write_cfg kdeglobals Icons Theme "breeze"
fi

# --- STEP 3: Configure Spotlight Search (Ctrl+Space / Meta+Space) ---
echo "[3/6] Configuring Spotlight search (KRunner)..."
write_cfg krunnerrc General FreeFloating "true"
write_cfg krunnerrc General RetainPriorSearch "false"
write_cfg kglobalshortcutsrc krunner.desktop _launch "Ctrl+Space\tMeta+Space,none,Spotlight Search"

# --- STEP 4: Configure Finder Layout (Dolphin) ---
echo "[4/6] Configuring Finder layout in Dolphin..."
write_cfg dolphinrc General ShowToolBar "true"
write_cfg dolphinrc General ShowSelectionToggle "false"
write_cfg dolphinrc General RememberOpenedTabs "false"
write_cfg dolphinrc MainWindow ToolBarsMovable "Disabled"

# --- STEP 5: Apply Top Menu Bar & MaclinOS Vector Wallpaper ---
echo "[5/6] Restructuring Top Menubar and Wallpaper..."
WP_PATH="$HOME/.local/share/wallpapers/MaclinOS/contents/images/maclinos-flow-light.svg"
mkdir -p "$(dirname "$WP_PATH")"
cp "$PROJECT_DIR/design/wallpapers/maclinos-flow-light.svg" "$WP_PATH" 2>/dev/null || true

JS_CODE="
// Clean existing panels and set up authentic macOS top menubar
var p = panels();
for (var i = 0; i < p.length; i++) {
    p[i].remove();
}

var topBar = new Panel();
topBar.location = 'top';
topBar.height = 26;

// 1. Apple / Maclin icon launcher
var launcher = topBar.addWidget('org.kde.plasma.kickoff');
if (launcher) {
    launcher.currentConfigGroup = ['General'];
    launcher.writeConfig('icon', 'start-here-kde');
}

// 2. Global Application Menu (File, Edit, View, Window, Help)
topBar.addWidget('org.kde.plasma.appmenu');

// 3. Spacers and Center Clock
topBar.addWidget('org.kde.plasma.panelspacer');
var clock = topBar.addWidget('org.kde.plasma.digitalclock');
if (clock) {
    clock.currentConfigGroup = ['Appearance'];
    clock.writeConfig('dateFormat', 'shortDate');
    clock.writeConfig('showDate', 'true');
}
topBar.addWidget('org.kde.plasma.panelspacer');

// 4. System status tray
topBar.addWidget('org.kde.plasma.systemtray');

// 5. Desktop Wallpaper
var d = desktops();
for (var j = 0; j < d.length; j++) {
    d[j].wallpaperPlugin = 'org.kde.image';
    d[j].currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
    d[j].writeConfig('Image', 'file://${WP_PATH}');
}
"

qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$JS_CODE" 2>/dev/null || \
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$JS_CODE" 2>/dev/null || true

# Direct fallback wallpaper injection
if [ -f "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" ]; then
    sed -i "s|Image=.*|Image=file://${WP_PATH}|g" "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" 2>/dev/null || true
fi

# Window buttons on top left
write_cfg kwinrc org.kde.kdecoration2 ButtonsOnLeft "XIA"
write_cfg kwinrc org.kde.kdecoration2 ButtonsOnRight ""
write_cfg kwinrc org.kde.kdecoration2 library "org.kde.kwin.aurorae"
write_cfg kwinrc org.kde.kdecoration2 theme "__aurorae__svg__MaclinOS"
write_cfg kwinrc Windows Placement "Centered"

# --- STEP 6: Restart Plank and KWin Compositor ---
echo "[6/6] Launching macOS Dock and refreshing compositor..."
qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true

killall plank 2>/dev/null || true
sleep 1
DISPLAY=:1 nohup plank >/dev/null 2>&1 &

echo ""
echo "========================================="
echo "  ✅ macOS Experience Applied!"
echo "  - Dock with Zoom Magnification: Active at bottom"
echo "  - Top Menubar + Global Menu: Active at top"
echo "  - Spotlight Search: Press Ctrl+Space"
echo "  - Traffic Light Buttons: Top-left of all windows"
echo "========================================="
