# MaclinOS Hardware Matrix

## Minimum Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| Architecture | x86_64 (amd64) | x86_64 (amd64) |
| CPU | 64-bit dual-core, 1.5 GHz | 64-bit quad-core, 2.0 GHz+ |
| RAM | 4 GB | 8 GB+ |
| Disk | 20 GB | 40 GB+ (SSD recommended) |
| GPU | Any with KMS driver | Intel/AMD with Vulkan |
| Display | 1280×720 | 1920×1080+ |
| Network | Ethernet or supported Wi-Fi | Wi-Fi 5/6 |
| Boot | UEFI (64-bit) | UEFI with Secure Boot |

## GPU Support Matrix

| Vendor | Driver | Wayland | Status | Notes |
|--------|--------|---------|--------|-------|
| Intel (Gen 9+) | i915 (modesetting) | ✅ Full | 🟢 Primary target | Best out-of-box experience |
| AMD (GCN 1.0+) | amdgpu | ✅ Full | 🟢 Primary target | Excellent open-source support |
| AMD (older) | radeon | ⚠️ Limited | 🟡 Supported | Some compositing limitations |
| NVIDIA (Turing+) | nvidia-driver (565+) | ⚠️ Partial | 🟡 Supported | Requires proprietary driver; test GBM |
| NVIDIA (older) | nouveau | ❌ Poor | 🔴 Not recommended | Limited performance, no Wayland |
| VM (virtio-gpu) | virtio_gpu | ✅ Full | 🟢 Development target | QEMU/KVM, VirtualBox |
| VM (VMware) | vmwgfx | ⚠️ Partial | 🟡 Functional | 3D acceleration varies |

## Laptop Features

| Feature | Technology | Status | Notes |
|---------|-----------|--------|-------|
| Touchpad gestures | libinput | 🟡 Partial | 3-4 finger configurable via KDE settings |
| HiDPI / Retina | KDE scaling | ✅ Full | 100%, 125%, 150%, 200% tested |
| Fractional scaling | KDE Wayland | 🟡 Beta | Some blur on non-integer scales |
| Suspend/resume | systemd | ✅ Full | Hardware dependent |
| Lid close | systemd-logind | ✅ Full | Configurable action |
| Brightness | sysfs backlight | ✅ Full | Fn keys via udev |
| Keyboard backlight | sysfs leds | 🟡 Hardware dependent | Not all keyboards |
| External monitors | KWin | ✅ Full | Hot-plug supported |
| USB-C / Thunderbolt | bolt daemon | 🟡 Hardware dependent | DisplayPort alt mode |

## Peripheral Support

| Device | Technology | Status | Notes |
|--------|-----------|--------|-------|
| USB storage | udisks2 | ✅ Full | Auto-mount configurable |
| Printers | CUPS | ✅ Full | Network and USB |
| Bluetooth audio | PipeWire + BlueZ | ✅ Full | A2DP, HFP profiles |
| Bluetooth devices | BlueZ | ✅ Full | KDE Bluetooth applet |
| Webcam | v4l2 | ✅ Full | UVC devices |
| Microphone | PipeWire | ✅ Full | Tested in browser |
| Wi-Fi | NetworkManager | ✅ Full | WPA2/3, enterprise |
| Game controllers | evdev/SDL | 🟡 Basic | Not a gaming focus |
| Fingerprint | fprintd | 🟡 Hardware dependent | Limited device support |

## Tested Hardware (to be populated)

| Make/Model | CPU | GPU | Wi-Fi | Status | Tester | Date |
|------------|-----|-----|-------|--------|--------|------|
| QEMU/KVM VM | virtio | virtio-gpu | virtio-net | 🟢 | — | — |
| VirtualBox VM | — | VBoxVGA | NAT | 🟢 | — | — |
| *(add tested hardware here)* | | | | | | |

---

## Testing Procedure

For each hardware target, test:

1. [ ] Boot from USB (UEFI)
2. [ ] Live session loads desktop
3. [ ] Wi-Fi connects
4. [ ] Audio output works
5. [ ] Display resolution and scaling correct
6. [ ] Install to disk completes
7. [ ] Reboot into installed system
8. [ ] Suspend/resume works
9. [ ] External monitor hot-plug
10. [ ] Bluetooth device pairing
11. [ ] USB device mount
12. [ ] Webcam and microphone
13. [ ] Touchpad gestures (laptops)
14. [ ] Brightness and volume keys (laptops)
15. [ ] apt update/upgrade succeeds
