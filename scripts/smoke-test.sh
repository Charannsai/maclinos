#!/bin/bash
# =============================================================================
# MaclinOS Smoke Tests
# =============================================================================
# Quick validation of a running MaclinOS installation or live session.
# Run from within the target system (VM or hardware).
#
# Usage: chmod +x scripts/smoke-test.sh && ./scripts/smoke-test.sh
# =============================================================================

set -uo pipefail

PASS=0
FAIL=0
WARN=0

pass() { echo "  ✅ PASS: $1"; ((PASS++)); }
fail() { echo "  ❌ FAIL: $1"; ((FAIL++)); }
warn() { echo "  ⚠️  WARN: $1"; ((WARN++)); }

echo "========================================="
echo "  MaclinOS Smoke Tests"
echo "  $(date -Iseconds)"
echo "========================================="
echo ""

# --- System Basics ---
echo "--- System Basics ---"

if [ -f /etc/debian_version ]; then
    pass "Debian base detected ($(cat /etc/debian_version))"
else
    fail "Not a Debian system"
fi

if uname -r | grep -q 'linux\|amd64'; then
    pass "Linux kernel running ($(uname -r))"
else
    fail "Unexpected kernel: $(uname -r)"
fi

if systemctl is-system-running --quiet 2>/dev/null; then
    pass "systemd is running"
else
    warn "systemd status: $(systemctl is-system-running 2>/dev/null || echo 'unknown')"
fi

echo ""

# --- Desktop Environment ---
echo "--- Desktop Environment ---"

if pgrep -x plasmashell >/dev/null 2>&1; then
    pass "Plasma shell is running"
else
    fail "Plasma shell is not running"
fi

if pgrep -x kwin_wayland >/dev/null 2>&1; then
    pass "KWin Wayland compositor is running"
elif pgrep -x kwin_x11 >/dev/null 2>&1; then
    warn "KWin X11 is running (Wayland preferred)"
else
    fail "KWin is not running"
fi

if pgrep -x sddm >/dev/null 2>&1 || systemctl is-active sddm --quiet 2>/dev/null; then
    pass "SDDM is running"
else
    warn "SDDM is not running (may be using another DM)"
fi

echo ""

# --- Theme Verification ---
echo "--- Theme Verification ---"

COLOR_SCHEME=$(kreadconfig6 --file kdeglobals --group General --key ColorScheme 2>/dev/null || echo "")
if [[ "$COLOR_SCHEME" == *"MaclinOS"* ]]; then
    pass "MaclinOS color scheme active ($COLOR_SCHEME)"
else
    warn "Color scheme is '$COLOR_SCHEME' (expected MaclinOS)"
fi

BUTTONS_LEFT=$(kreadconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft 2>/dev/null || echo "")
if [[ "$BUTTONS_LEFT" == "XIA" ]]; then
    pass "Window buttons on left (macOS style)"
else
    warn "Window buttons: left='$BUTTONS_LEFT' (expected 'XIA')"
fi

BLUR_ENABLED=$(kreadconfig6 --file kwinrc --group Plugins --key blurEnabled 2>/dev/null || echo "")
if [[ "$BLUR_ENABLED" == "true" ]]; then
    pass "Blur effect enabled"
else
    warn "Blur effect not enabled"
fi

if [ -d "$HOME/.local/share/color-schemes" ] && ls "$HOME/.local/share/color-schemes/MaclinOS"* >/dev/null 2>&1; then
    pass "MaclinOS color scheme files installed (user)"
elif [ -f "/usr/share/color-schemes/MaclinOS.colors" ]; then
    pass "MaclinOS color scheme files installed (system)"
else
    warn "MaclinOS color scheme files not found"
fi

echo ""

# --- Networking ---
echo "--- Networking ---"

if systemctl is-active NetworkManager --quiet 2>/dev/null; then
    pass "NetworkManager is active"
else
    fail "NetworkManager is not active"
fi

if ping -c 1 -W 3 1.1.1.1 >/dev/null 2>&1; then
    pass "Internet connectivity (ping)"
else
    warn "No internet connectivity"
fi

if nmcli -t -f TYPE,STATE dev | grep -q 'wifi:connected'; then
    pass "Wi-Fi connected"
elif nmcli -t -f TYPE dev | grep -q 'wifi'; then
    warn "Wi-Fi adapter present but not connected"
else
    warn "No Wi-Fi adapter detected"
fi

echo ""

# --- Audio ---
echo "--- Audio ---"

if systemctl --user is-active pipewire --quiet 2>/dev/null; then
    pass "PipeWire is running"
elif pgrep -x pipewire >/dev/null 2>&1; then
    pass "PipeWire process found"
else
    fail "PipeWire is not running"
fi

if pactl info >/dev/null 2>&1; then
    pass "PulseAudio interface accessible (via PipeWire)"
else
    warn "PulseAudio interface not accessible"
fi

echo ""

# --- Applications ---
echo "--- Applications ---"

for app in dolphin konsole firefox-esr systemsettings; do
    if command -v "$app" >/dev/null 2>&1 || dpkg -l "$app" 2>/dev/null | grep -q '^ii'; then
        pass "$app is installed"
    else
        fail "$app is not installed"
    fi
done

echo ""

# --- Package Management ---
echo "--- Package Management ---"

if command -v apt >/dev/null 2>&1; then
    pass "apt is available"
else
    fail "apt is not available"
fi

if apt update --print-uris >/dev/null 2>&1; then
    pass "apt repositories are reachable"
else
    warn "apt repositories may not be reachable"
fi

echo ""

# --- Accessibility ---
echo "--- Accessibility ---"

if command -v orca >/dev/null 2>&1; then
    pass "Orca screen reader is installed"
else
    warn "Orca screen reader not found"
fi

if dpkg -l at-spi2-core 2>/dev/null | grep -q '^ii'; then
    pass "AT-SPI2 accessibility bridge installed"
else
    warn "AT-SPI2 not installed"
fi

echo ""

# --- Performance Baseline ---
echo "--- Performance ---"

IDLE_RAM=$(free -m | awk '/^Mem:/{print $3}')
echo "  ℹ️  Idle RAM usage: ${IDLE_RAM} MB"
if [ "$IDLE_RAM" -lt 2000 ]; then
    pass "RAM usage under 2 GB idle"
elif [ "$IDLE_RAM" -lt 3000 ]; then
    warn "RAM usage ${IDLE_RAM} MB (target < 2 GB)"
else
    fail "RAM usage ${IDLE_RAM} MB (too high for idle)"
fi

BOOT_TIME=$(systemd-analyze 2>/dev/null | head -1 || echo "unknown")
echo "  ℹ️  Boot time: $BOOT_TIME"

echo ""

# --- Summary ---
echo "========================================="
echo "  Results: ✅ $PASS passed, ❌ $FAIL failed, ⚠️  $WARN warnings"
echo "========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
else
    exit 0
fi
