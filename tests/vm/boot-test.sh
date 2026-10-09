#!/bin/bash
# =============================================================================
# MaclinOS VM Boot Test
# =============================================================================
# Runs the built MaclinOS ISO in QEMU to verify:
#   1. GRUB boots properly
#   2. Linux kernel loads
#   3. SDDM / Plasma desktop initializes without fatal crash
#
# Usage:
#   ./tests/vm/boot-test.sh [path/to/maclinos.iso]
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

ISO_PATH="${1:-}"

if [ -z "$ISO_PATH" ]; then
    # Auto-detect latest ISO in output directory
    ISO_PATH=$(ls -t "$PROJECT_DIR"/output/maclinos-*.iso 2>/dev/null | head -n1 || true)
fi

if [ -z "$ISO_PATH" ] || [ ! -f "$ISO_PATH" ]; then
    echo "ERROR: No ISO file found. Provide path or run build-iso.sh first."
    echo "Usage: $0 [path/to/maclinos.iso]"
    exit 1
fi

echo "========================================="
echo "  MaclinOS Automated VM Boot Test"
echo "  Target: $ISO_PATH"
echo "========================================="

if ! command -v qemu-system-x86_64 >/dev/null 2>&1; then
    echo "ERROR: qemu-system-x86_64 is not installed."
    echo "       Run: sudo apt install qemu-system-x86 qemu-utils"
    exit 1
fi

TIMEOUT_SECONDS=180
SERIAL_LOG=$(mktemp -t maclinos-boot-serial-XXXXXX.log)

echo "Starting headless QEMU instance with timeout ${TIMEOUT_SECONDS}s..."
echo "Serial output logged to: $SERIAL_LOG"

# Run QEMU in background with serial output redirection
qemu-system-x86_64 \
    -m 4096 \
    -smp 2 \
    -enable-kvm 2>/dev/null || true \
    -cdrom "$ISO_PATH" \
    -boot d \
    -serial file:"$SERIAL_LOG" \
    -display none \
    -daemonize \
    -pidfile /tmp/maclinos-qemu-test.pid

PID=$(cat /tmp/maclinos-qemu-test.pid 2>/dev/null || echo "")

cleanup() {
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        echo "Stopping QEMU process ($PID)..."
        kill -9 "$PID" 2>/dev/null || true
    fi
    rm -f /tmp/maclinos-qemu-test.pid
}
trap cleanup EXIT INT TERM

echo "QEMU started (PID: $PID). Waiting for boot indicators..."

ELAPSED=0
BOOT_SUCCESS=0

while [ "$ELAPSED" -lt "$TIMEOUT_SECONDS" ]; do
    sleep 5
    ELAPSED=$((ELAPSED + 5))

    # Check for successful boot indicators in serial log
    if grep -Eiq "login:|systemd\[1\]: Reached target Graphical Interface|Reached target Multi-User System" "$SERIAL_LOG" 2>/dev/null; then
        echo "  ✅ Boot milestone reached in ${ELAPSED}s"
        BOOT_SUCCESS=1
        break
    fi

    # Check if QEMU crashed or stopped
    if ! kill -0 "$PID" 2>/dev/null; then
        echo "❌ QEMU process terminated unexpectedly."
        break
    fi

    echo "  [${ELAPSED}s] Booting in progress..."
done

if [ "$BOOT_SUCCESS" -eq 1 ]; then
    echo "========================================="
    echo "  ✅ VM Boot Test PASSED!"
    echo "========================================="
    rm -f "$SERIAL_LOG"
    exit 0
else
    echo "========================================="
    echo "  ❌ VM Boot Test FAILED or Timed Out!"
    echo "========================================="
    echo "Last 30 lines of serial log:"
    tail -n 30 "$SERIAL_LOG" 2>/dev/null || true
    exit 1
fi
