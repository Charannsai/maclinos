#!/bin/bash
# =============================================================================
# MaclinOS Development Environment Setup
# =============================================================================
# Run this on a Debian 13 (Trixie) system to install all development tools.
# Usage: chmod +x scripts/setup-dev.sh && ./scripts/setup-dev.sh
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================="
echo "  MaclinOS Development Environment Setup"
echo "========================================="
echo ""
echo "Project directory: $PROJECT_DIR"
echo "Debian version:    $(cat /etc/debian_version 2>/dev/null || echo 'unknown')"
echo ""

# --- Check we're on Debian ---
if ! grep -qi 'debian\|trixie' /etc/os-release 2>/dev/null; then
    echo "WARNING: This script is designed for Debian 13 (Trixie)."
    echo "         Current system may not be compatible."
    read -p "Continue anyway? [y/N] " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
fi

# --- Update system ---
echo "[1/6] Updating system packages..."
sudo apt update
sudo apt upgrade -y

# --- Install core development tools ---
echo "[2/6] Installing development tools..."
sudo apt install -y \
    git \
    build-essential \
    cmake \
    extra-cmake-modules \
    devscripts \
    debhelper \
    dh-make \
    lintian \
    fakeroot

# --- Install KDE/Plasma development tools ---
echo "[3/6] Installing KDE Plasma SDK and development libraries..."
sudo apt install -y \
    plasma-sdk \
    qtcreator \
    qt6-base-dev \
    qt6-declarative-dev \
    qt6-tools-dev \
    qml6-module-qtquick \
    qml6-module-qtquick-controls \
    qml6-module-qtquick-layouts \
    libkf6config-dev \
    libkf6coreaddons-dev \
    libkf6i18n-dev \
    libkf6windowsystem-dev \
    kirigami2-dev \
    gettext

# --- Install graphics tools ---
echo "[4/6] Installing graphics tools..."
sudo apt install -y \
    inkscape \
    gimp \
    imagemagick \
    optipng \
    svgo 2>/dev/null || sudo apt install -y \
    inkscape \
    gimp \
    imagemagick \
    optipng

# --- Install ISO build tools ---
echo "[5/6] Installing ISO build tools..."
sudo apt install -y \
    live-build \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-common \
    grub-efi-amd64-bin

# --- Install testing tools ---
echo "[6/6] Installing testing tools..."
sudo apt install -y \
    qemu-system-x86 \
    qemu-utils \
    ovmf \
    xdotool \
    xvfb

# --- Record baseline system info ---
echo ""
echo "========================================="
echo "  Recording system baseline..."
echo "========================================="

BASELINE_FILE="$PROJECT_DIR/docs/baseline.txt"
{
    echo "MaclinOS Development Baseline"
    echo "Generated: $(date -Iseconds)"
    echo ""
    echo "--- System ---"
    uname -a
    echo ""
    echo "--- Debian Version ---"
    cat /etc/debian_version
    echo ""
    echo "--- CPU ---"
    lscpu | head -20
    echo ""
    echo "--- Memory ---"
    free -h
    echo ""
    echo "--- GPU ---"
    lspci | grep -i vga || echo "No VGA device found"
    echo ""
    echo "--- Display ---"
    echo "Resolution: $(xdpyinfo 2>/dev/null | grep dimensions | awk '{print $2}' || echo 'N/A')"
    echo "Scale: $(kreadconfig6 --group KScreen --key ScaleFactor 2>/dev/null || echo 'N/A')"
    echo ""
    echo "--- Plasma Version ---"
    plasmashell --version 2>/dev/null || echo "Plasma not running"
    echo ""
    echo "--- KWin Version ---"
    kwin_wayland --version 2>/dev/null || echo "KWin not available"
    echo ""
    echo "--- Qt Version ---"
    qmake6 --version 2>/dev/null || echo "Qt6 qmake not found"
    echo ""
    echo "--- Disk ---"
    df -h / | tail -1
    echo ""
    echo "--- Key Package Versions ---"
    dpkg -l | grep -E '^ii\s+(plasma-desktop|kwin|sddm|pipewire|network-manager)' || echo "Packages not installed"
} > "$BASELINE_FILE"

echo "Baseline saved to: $BASELINE_FILE"

# --- Initialize git repo if not already ---
if [ ! -d "$PROJECT_DIR/.git" ]; then
    echo ""
    echo "Initializing git repository..."
    cd "$PROJECT_DIR"
    git init
    git add -A
    git commit -m "Initial MaclinOS project scaffold"
fi

echo ""
echo "========================================="
echo "  ✅ Development environment ready!"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Review docs/baseline.txt for system info"
echo "  2. Take a VM snapshot before making changes"
echo "  3. Start with: ./scripts/apply-theme.sh"
echo ""
