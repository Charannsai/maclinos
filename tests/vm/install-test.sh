#!/bin/bash
# =============================================================================
# MaclinOS Installation Verification Test
# =============================================================================
# Verifies that Calamares / debian-installer configuration and post-install
# setup correctly generate a functioning target root partition.
#
# Usage:
#   ./tests/vm/install-test.sh [TARGET_ROOT_MOUNT]
# =============================================================================

set -uo pipefail

TARGET_ROOT="${1:-/}"

echo "========================================="
echo "  MaclinOS Installation Verification Test"
echo "  Target root: $TARGET_ROOT"
echo "========================================="
echo ""

PASS=0
FAIL=0

pass() { echo "  ✅ PASS: $1"; ((PASS++)); }
fail() { echo "  ❌ FAIL: $1"; ((FAIL++)); }

# Check fstab
if [ -s "$TARGET_ROOT/etc/fstab" ]; then
    pass "Target /etc/fstab exists and is not empty"
else
    fail "Target /etc/fstab missing or empty"
fi

# Check SDDM setup
if [ -f "$TARGET_ROOT/etc/sddm.conf.d/maclinos.conf" ]; then
    pass "SDDM MaclinOS configuration is present in /etc/sddm.conf.d/"
else
    fail "SDDM MaclinOS configuration missing"
fi

# Check skel configurations
if [ -f "$TARGET_ROOT/etc/skel/.config/kdeglobals" ] && [ -f "$TARGET_ROOT/etc/skel/.config/kwinrc" ]; then
    pass "User skeleton files (.config/kdeglobals, .config/kwinrc) exist"
else
    fail "User skeleton files missing from /etc/skel/.config"
fi

# Check essential core binaries
for bin in /usr/bin/plasmashell /usr/bin/kwin_wayland /usr/bin/dolphin /usr/bin/konsole; do
    if [ -x "$TARGET_ROOT$bin" ]; then
        pass "Core binary present: $bin"
    else
        fail "Core binary missing: $bin"
    fi
done

# Check PipeWire sound server
if [ -x "$TARGET_ROOT/usr/bin/pipewire" ] && [ -x "$TARGET_ROOT/usr/bin/wireplumber" ]; then
    pass "PipeWire & WirePlumber installed"
else
    fail "PipeWire or WirePlumber missing"
fi

echo ""
echo "========================================="
echo "  Install Test Summary: ✅ $PASS passed, ❌ $FAIL failed"
echo "========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
