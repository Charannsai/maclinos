// MaclinOS Plasma Desktop Layout Script
// Configures macOS-style top bar and floating bottom dock

// 1. Remove all default panels
var allPanels = panels();
for (var i = 0; i < allPanels.length; ++i) {
    allPanels[i].remove();
}

// 2. Create Top Bar (macOS Menubar)
var topBar = new Panel();
topBar.location = "top";
topBar.height = 28;

// Top Bar Widgets: Launcher -> Global Menu -> Spacer -> Clock -> Spacer -> System Tray
var launcher = topBar.addWidget("org.kde.plasma.kickoff");
if (launcher) {
    launcher.currentConfigGroup = ["General"];
    launcher.writeConfig("icon", "start-here-kde");
}

var globalMenu = topBar.addWidget("org.kde.plasma.appmenu");
var leftSpacer = topBar.addWidget("org.kde.plasma.panelspacer");
var clock = topBar.addWidget("org.kde.plasma.digitalclock");
var rightSpacer = topBar.addWidget("org.kde.plasma.panelspacer");
var tray = topBar.addWidget("org.kde.plasma.systemtray");

// 3. Create Bottom Dock
var dock = new Panel();
dock.location = "bottom";
dock.height = 60;
dock.alignment = "center";
dock.hiding = "dodgewindows";

var tasks = dock.addWidget("org.kde.plasma.icontasks");
