#!/bin/bash
# =============================================================================
# MaclinOS Recovery Procedure Verification Test
# =============================================================================
# Simulates desktop configuration corruption and verifies that
# scripts/recover-desktop.sh properly backs up corrupt config and restores defaults.
#
# Usage:
#   ./tests/vm/recovery-test.sh
# =============================================================================

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "========================================="
echo "  MaclinOS Recovery Procedure Test"
echo "========================================="
echo ""

PASS=0
FAIL=0

pass() { echo "  ✅ PASS: $1"; ((PASS++)); }
fail() { echo "  ❌ FAIL: $1"; ((FAIL++)); }

TEST_HOME=$(mktemp -d -t maclinos-recovery-test-XXXXXX)
export HOME="$TEST_HOME"

cleanup() {
    rm -rf "$TEST_HOME"
}
trap cleanup EXIT

mkdir -p "$TEST_HOME/.config"

echo "1. Simulating corrupted user configs..."
echo "[Corrupted] InvalidData=true" > "$TEST_HOME/.config/kdeglobals"
echo "[Broken] ButtonLayout=ZZZZ" > "$TEST_HOME/.config/kwinrc"

echo "2. Executing recover-desktop.sh with --force..."
if bash "$PROJECT_DIR/scripts/recover-desktop.sh" --force >/dev/null 2>&1; then
    pass "Recovery script ran without exit errors"
else
    fail "Recovery script execution returned error code"
fi

echo "3. Validating restoration and backup..."
BACKUP_COUNT=$(find "$TEST_HOME/.config" -maxdepth 1 -name "maclinos-backup-*" | wc -l)
if [ "$BACKUP_COUNT" -ge 1 ]; then
    pass "Backup folder was created successfully"
else
    fail "No backup directory found"
fi

if grep -q "ColorScheme=MaclinOS" "$TEST_HOME/.config/kdeglobals" 2>/dev/null; then
    pass "Default ColorScheme=MaclinOS restored in kdeglobals"
else
    fail "kdeglobals ColorScheme not restored"
fi

if grep -q "ButtonsOnLeft=XIA" "$TEST_HOME/.config/kwinrc" 2>/dev/null; then
    pass "Default window button layout (ButtonsOnLeft=XIA) restored"
else
    fail "kwinrc button layout not restored"
fi

echo ""
echo "========================================="
echo "  Recovery Summary: ✅ $PASS passed, ❌ $FAIL failed"
echo "========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
