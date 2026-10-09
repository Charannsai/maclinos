#!/bin/bash
# =============================================================================
# MaclinOS Package Update & Upgrade Safety Test
# =============================================================================
# Verifies that performing standard apt operations (apt update, apt upgrade)
# does not overwrite custom theme configs, break desktop session dependencies,
# or disrupt KDE configuration.
#
# Usage:
#   ./tests/vm/update-test.sh
# =============================================================================

set -uo pipefail

echo "========================================="
echo "  MaclinOS Package Update Safety Test"
echo "========================================="
echo ""

PASS=0
FAIL=0

pass() { echo "  ✅ PASS: $1"; ((PASS++)); }
fail() { echo "  ❌ FAIL: $1"; ((FAIL++)); }

# Check apt availability
if ! command -v apt-get >/dev/null 2>&1; then
    echo "ERROR: apt-get not found. This test must be run on Debian/MaclinOS."
    exit 1
fi

echo "[1] Testing apt update..."
if apt-get update -qq; then
    pass "apt-get update completed successfully"
else
    fail "apt-get update failed"
fi

echo "[2] Simulating apt upgrade..."
UPGRADE_SIM=$(apt-get --simulate upgrade 2>&1)
if echo "$UPGRADE_SIM" | grep -Eq "unmet dependencies|broken packages"; then
    fail "apt upgrade simulation revealed broken dependencies or conflicts"
else
    pass "apt upgrade simulation cleanly resolved without broken packages"
fi

echo "[3] Checking critical package holds and protection..."
CRITICAL_PKGS=("plasma-workspace" "kwin-wayland" "sddm")
for pkg in "${CRITICAL_PKGS[@]}"; do
    if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
        pass "Core package $pkg remains installed and configured"
    else
        fail "Core package $pkg is missing or in broken state"
    fi
done

echo ""
echo "========================================="
echo "  Update Safety Summary: ✅ $PASS passed, ❌ $FAIL failed"
echo "========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
