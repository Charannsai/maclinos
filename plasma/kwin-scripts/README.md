# MaclinOS KWin Scripts
#
# Place KWin scripts for custom window management behaviors here.
# Each script should be a separate directory with:
#   metadata.desktop  - Script metadata
#   contents/
#     code/
#       main.js        - Main script
#
# Potential scripts:
#   - Window snapping/tiling with macOS-style animations
#   - Custom hot corner behaviors
#   - Window grouping/stacking rules
#   - Focus-follows-mouse alternatives
#
# Guidelines:
#   - Use the KWin scripting API, not patching KWin source
#   - Test thoroughly; broken KWin scripts can make windows unmanageable
#   - Always provide a disable/unload mechanism
#   - See: https://develop.kde.org/docs/plasma/kwin/
