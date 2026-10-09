#!/bin/bash
# =============================================================================
# MaclinOS Theme Integrity Test
# =============================================================================
# Validates that all theme assets, color schemes, desktop layouts,
# and window decorations are installed in their expected paths and syntactically valid.
#
# Usage:
#   ./tests/vm/theme-test.sh
# =============================================================================

set -uo pipefail

PASS=0
FAIL=0

pass() { echo "  ✅ PASS: $1"; ((PASS++)); }
fail() { echo "  ❌ FAIL: $1"; ((FAIL++)); }

echo "========================================="
echo "  MaclinOS Theme Integrity Test"
echo "========================================="
echo ""

# 1. Color Schemes
echo "[1] Checking Color Schemes..."
for theme in MaclinOS MaclinOSDark; do
    file_found=0
    for path in "$HOME/.local/share/color-schemes/${theme}.colors" "/usr/share/color-schemes/${theme}.colors" "./plasma/color-schemes/${theme}.colors"; do
        if [ -f "$path" ]; then
            file_found=1
            if grep -q "\[Colors:Window\]" "$path" && grep -q "\[Colors:View\]" "$path"; then
                pass "Color scheme $theme is valid ($path)"
            else
                fail "Color scheme $theme is missing required sections ($path)"
            fi
            break
        fi
    done
    if [ "$file_found" -eq 0 ]; then
        fail "Color scheme $theme not found"
    fi
done

# 2. Window Decorations (Aurorae)
echo ""
echo "[2] Checking Window Decorations..."
for asset in close.svg minimize.svg maximize.svg MaclinOSrc; do
    asset_found=0
    for dir in "$HOME/.local/share/aurorae/themes/MaclinOS" "/usr/share/aurorae/themes/MaclinOS" "./plasma/window-decorations/MaclinOS"; do
        if [ -f "$dir/$asset" ]; then
            asset_found=1
            pass "Window decoration asset: $asset found in $dir"
            break
        fi
    done
    if [ "$asset_found" -eq 0 ]; then
        fail "Window decoration asset: $asset missing"
    fi
done

# 3. SDDM Theme
echo ""
echo "[3] Checking SDDM Theme..."
for sddm_file in Main.qml metadata.desktop theme.conf; do
    sddm_found=0
    for sddm_dir in "/usr/share/sddm/themes/MaclinOS" "./plasma/sddm/MaclinOS"; do
        if [ -f "$sddm_dir/$sddm_file" ]; then
            sddm_found=1
            pass "SDDM theme file: $sddm_file present"
            break
        fi
    done
    if [ "$sddm_found" -eq 0 ]; then
        fail "SDDM theme file: $sddm_file missing"
    fi
done

# 4. KWin Configuration
echo ""
echo "[4] Checking KWin Window Management Settings..."
if command -v kreadconfig6 >/dev/null 2>&1; then
    BUTTONS=$(kreadconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft 2>/dev/null || echo "")
    if [ "$BUTTONS" = "XIA" ]; then
        pass "KWin ButtonsOnLeft is correctly set to 'XIA' (close/minimize/maximize on left)"
    else
        fail "KWin ButtonsOnLeft is '$BUTTONS' (expected 'XIA')"
    fi
else
    echo "  ℹ️  kreadconfig6 not found in PATH; skipping runtime kwinrc evaluation"
fi

# 5. Wallpapers
echo ""
echo "[5] Checking Wallpaper Assets..."
WALLPAPER_FOUND=0
for wp_dir in "/usr/share/wallpapers/MaclinOS" "./design/wallpapers"; do
    if [ -d "$wp_dir" ] && ls "$wp_dir"/*.{jpg,png,svg} 1>/dev/null 2>&1; then
        WALLPAPER_FOUND=1
        pass "Wallpaper assets found in $wp_dir"
        break
    fi
done
if [ "$WALLPAPER_FOUND" -eq 0 ]; then
    fail "No wallpaper image files (.jpg, .png, .svg) found in wallpaper paths"
fi

echo ""
echo "========================================="
echo "  Theme Integrity Summary: ✅ $PASS passed, ❌ $FAIL failed"
echo "========================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
