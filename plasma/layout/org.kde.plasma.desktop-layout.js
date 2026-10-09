[LayoutDefault]
rows=1
columns=2

# --- Top Bar Panel ---
[LayoutDefault-panel0]
location=top
height=28
maximumLength=0
minimumLength=0
alignment=fill

# Left: Application Menu (global menu)
[LayoutDefault-panel0-plugin0]
plugin=org.kde.plasma.appmenu

# Center spacer (pushes clock to center)
[LayoutDefault-panel0-plugin1]
plugin=org.kde.plasma.panelspacer

# Center: Digital Clock
[LayoutDefault-panel0-plugin2]
plugin=org.kde.plasma.digitalclock

# Right spacer (pushes tray to right)
[LayoutDefault-panel0-plugin3]
plugin=org.kde.plasma.panelspacer

# Right: System Tray
[LayoutDefault-panel0-plugin4]
plugin=org.kde.plasma.systemtray

# --- Bottom Dock Panel ---
[LayoutDefault-panel1]
location=bottom
height=68
maximumLength=0
minimumLength=0
alignment=center
floating=1
hiding=dodgewindows

# Icon-Only Task Manager (dock behavior)
[LayoutDefault-panel1-plugin0]
plugin=org.kde.plasma.icontasks
