#!/bin/bash
# =============================================================================
# MaclinOS ISO Builder
# =============================================================================
# Builds a bootable Debian-based ISO with MaclinOS theming.
#
# Prerequisites:
#   - Debian 13 (Trixie) build environment
#   - Root privileges (sudo)
#   - live-build installed (apt install live-build)
#   - ~10 GB free disk space
#
# Usage: sudo ./scripts/build-iso.sh
#
# WARNING: Do NOT run this on your daily-use machine without reviewing.
#          Use a dedicated build VM or CI environment.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_DIR/image"
OUTPUT_DIR="$PROJECT_DIR/output"
VERSION="0.1.0"
CODENAME="trixie"
ARCH="amd64"
DATE="$(date +%Y%m%d)"
ISO_NAME="maclinos-${VERSION}-${ARCH}-${DATE}"

echo "========================================="
echo "  MaclinOS ISO Builder"
echo "  Version: $VERSION"
echo "  Codename: $CODENAME"
echo "  Architecture: $ARCH"
echo "========================================="
echo ""

# --- Pre-flight checks ---
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root (sudo)."
    exit 1
fi

if ! command -v lb >/dev/null 2>&1; then
    echo "ERROR: live-build is not installed."
    echo "       Run: sudo apt install live-build"
    exit 1
fi

# --- Clean previous build ---
echo "[1/6] Preparing build directory..."
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

if [ -f ".build/config" ]; then
    echo "  Cleaning previous build..."
    lb clean --purge 2>/dev/null || true
fi

# --- Configure live-build ---
echo "[2/6] Configuring live-build..."
lb config \
    --distribution "$CODENAME" \
    --architectures "$ARCH" \
    --binary-images iso-hybrid \
    --bootloaders "grub-efi" \
    --debian-installer live \
    --debian-installer-gui true \
    --security true \
    --updates true \
    --iso-application "MaclinOS" \
    --iso-publisher "MaclinOS Project" \
    --iso-volume "MaclinOS ${VERSION}" \
    --image-name "$ISO_NAME" \
    --apt-recommends true \
    --firmware-binary true \
    --firmware-chroot true \
    --memtest none

# --- Create package lists ---
echo "[3/6] Creating package lists..."
mkdir -p config/package-lists

# Core desktop
cat > config/package-lists/desktop.list.chroot << 'PKGEOF'
# KDE Plasma Desktop
plasma-desktop
plasma-workspace
kwin-wayland
kwin-wayland-backend-drm
sddm
plasma-nm
plasma-pa
plasma-systemmonitor
plasma-disks
bluedevil
powerdevil
kde-spectacle
kdeplasma-addons

# KDE Applications
dolphin
konsole
kate
gwenview
ark
okular
kcalc
kscreen
kde-config-sddm

# System
systemd
network-manager
pipewire
pipewire-pulse
wireplumber
bluez
cups
system-config-printer

# Fonts
fonts-inter
fonts-jetbrains-mono
fonts-noto
fonts-noto-color-emoji

# Browser
firefox-esr

# Firmware (redistributable)
firmware-linux-free
firmware-misc-nonfree
intel-microcode
amd64-microcode

# Accessibility
orca
at-spi2-core

# Utilities
bash-completion
file
less
man-db
wget
curl
nano
htop

# Flatpak (optional)
flatpak
plasma-discover-backend-flatpak

# Installer support
calamares
calamares-settings-debian
PKGEOF

echo "  ✓ Package lists created"

# --- Include MaclinOS theme assets ---
echo "[4/6] Including MaclinOS theme assets..."
CHROOT_DIR="config/includes.chroot"

# Color schemes
mkdir -p "$CHROOT_DIR/usr/share/color-schemes"
cp "$PROJECT_DIR/plasma/color-schemes/"*.colors "$CHROOT_DIR/usr/share/color-schemes/" 2>/dev/null || true

# SDDM theme
mkdir -p "$CHROOT_DIR/usr/share/sddm/themes/MaclinOS"
cp "$PROJECT_DIR/plasma/sddm/MaclinOS/"* "$CHROOT_DIR/usr/share/sddm/themes/MaclinOS/" 2>/dev/null || true

# Window decorations
mkdir -p "$CHROOT_DIR/usr/share/aurorae/themes/MaclinOS"
cp "$PROJECT_DIR/plasma/window-decorations/MaclinOS/"* "$CHROOT_DIR/usr/share/aurorae/themes/MaclinOS/" 2>/dev/null || true

# Global theme
mkdir -p "$CHROOT_DIR/usr/share/plasma/look-and-feel/MaclinOS/contents"
cp "$PROJECT_DIR/plasma/global-theme/metadata.desktop" "$CHROOT_DIR/usr/share/plasma/look-and-feel/MaclinOS/" 2>/dev/null || true
cp -r "$PROJECT_DIR/plasma/global-theme/contents/"* "$CHROOT_DIR/usr/share/plasma/look-and-feel/MaclinOS/contents/" 2>/dev/null || true

# Wallpapers
mkdir -p "$CHROOT_DIR/usr/share/wallpapers/MaclinOS/contents/images"
cp "$PROJECT_DIR/design/wallpapers/"* "$CHROOT_DIR/usr/share/wallpapers/MaclinOS/contents/images/" 2>/dev/null || true

# Skeleton config (defaults for new users)
SKEL_DIR="$CHROOT_DIR/etc/skel"
mkdir -p "$SKEL_DIR/.config"

# Apply MaclinOS as default color scheme for new users
cat > "$SKEL_DIR/.config/kdeglobals" << 'SKELEOF'
[General]
ColorScheme=MaclinOS
font=Inter,10,-1,5,50,0,0,0,0,0
fixed=JetBrains Mono,10,-1,5,50,0,0,0,0,0
smallestReadableFont=Inter,8,-1,5,50,0,0,0,0,0
toolBarFont=Inter,9,-1,5,50,0,0,0,0,0
menuFont=Inter,10,-1,5,50,0,0,0,0,0

[WM]
activeFont=Inter,10,-1,5,50,0,0,0,0,0

[Icons]
Theme=breeze
SKELEOF

cat > "$SKEL_DIR/.config/kwinrc" << 'SKELEOF'
[org.kde.kdecoration2]
ButtonsOnLeft=XIA
ButtonsOnRight=
BorderSize=None
BorderSizeAuto=false

[Windows]
Placement=Centered
FocusPolicy=ClickToFocus

[Compositing]
AnimationSpeed=3

[Plugins]
blurEnabled=true
contrastEnabled=true
overviewEnabled=true
slideEnabled=true
magiclampEnabled=true

[Effect-overview]
BorderActivate=9
SKELEOF

# SDDM configuration
mkdir -p "$CHROOT_DIR/etc/sddm.conf.d"
cat > "$CHROOT_DIR/etc/sddm.conf.d/maclinos.conf" << 'SDDMEOF'
[Theme]
Current=MaclinOS

[General]
InputMethod=

[Wayland]
SessionDir=/usr/share/wayland-sessions
SDDMEOF

echo "  ✓ Theme assets included"

# --- Build hooks ---
echo "[5/6] Creating build hooks..."
mkdir -p config/hooks/normal

cat > config/hooks/normal/0100-maclinos-setup.hook.chroot << 'HOOKEOF'
#!/bin/bash
# MaclinOS post-install hook
set -e

# Enable services
systemctl enable sddm
systemctl enable NetworkManager
systemctl enable bluetooth

# Set default session to Plasma Wayland
echo "[Desktop]" > /etc/sddm.conf.d/session.conf
echo "Session=plasma.desktop" >> /etc/sddm.conf.d/session.conf

# Set timezone (user will change during install)
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

echo "MaclinOS setup hook complete."
HOOKEOF

chmod +x config/hooks/normal/0100-maclinos-setup.hook.chroot

echo "  ✓ Build hooks created"

# --- Build ISO ---
echo "[6/6] Building ISO..."
echo "       This will take 15-60 minutes depending on network and disk speed."
echo ""

lb build 2>&1 | tee "$PROJECT_DIR/output/build-${DATE}.log" || {
    echo ""
    echo "ERROR: ISO build failed. Check the log at:"
    echo "       $PROJECT_DIR/output/build-${DATE}.log"
    exit 1
}

# --- Post-build ---
mkdir -p "$OUTPUT_DIR"

if [ -f "${ISO_NAME}.hybrid.iso" ]; then
    mv "${ISO_NAME}.hybrid.iso" "$OUTPUT_DIR/${ISO_NAME}.iso"
    cd "$OUTPUT_DIR"

    # Generate checksum
    sha256sum "${ISO_NAME}.iso" > "${ISO_NAME}.iso.sha256"

    # Generate package manifest
    if [ -f "$BUILD_DIR/chroot.packages.live" ]; then
        cp "$BUILD_DIR/chroot.packages.live" "${ISO_NAME}-manifest.txt"
    fi

    echo ""
    echo "========================================="
    echo "  ✅ ISO build complete!"
    echo "========================================="
    echo ""
    echo "  ISO:      $OUTPUT_DIR/${ISO_NAME}.iso"
    echo "  SHA256:   $OUTPUT_DIR/${ISO_NAME}.iso.sha256"
    echo "  Size:     $(du -h "${ISO_NAME}.iso" | cut -f1)"
    echo "  Manifest: $OUTPUT_DIR/${ISO_NAME}-manifest.txt"
    echo "  Log:      $OUTPUT_DIR/build-${DATE}.log"
    echo ""
    echo "  To test in QEMU:"
    echo "  qemu-system-x86_64 -enable-kvm -m 4G -bios /usr/share/OVMF/OVMF_CODE.fd \\"
    echo "    -cdrom $OUTPUT_DIR/${ISO_NAME}.iso"
    echo ""
else
    echo "ERROR: ISO file not found after build."
    echo "       Check the build log for errors."
    exit 1
fi
