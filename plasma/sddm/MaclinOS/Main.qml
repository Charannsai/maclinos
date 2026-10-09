import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0

/*
 * MaclinOS SDDM Login Theme
 *
 * A macOS-inspired login screen for SDDM.
 * Uses frosted glass effect over wallpaper, centered user avatar, and clean input fields.
 *
 * License: GPL-3.0-or-later
 * Author: MaclinOS Project
 */

Rectangle {
    id: root

    // SDDM properties
    property string defaultUser: userModel.lastUser
    property string defaultSession: sessionModel.lastIndex

    width: Screen.width
    height: Screen.height

    // Wallpaper background
    Image {
        id: wallpaper
        anchors.fill: parent
        source: "background.jpg"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        mipmap: true
    }

    // Blur overlay on wallpaper
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.3)
    }

    // Center login card
    Rectangle {
        id: loginCard
        anchors.centerIn: parent
        width: 320
        height: loginColumn.implicitHeight + 80
        radius: 20
        color: Qt.rgba(255/255, 255/255, 255/255, 0.15)
        border.color: Qt.rgba(255/255, 255/255, 255/255, 0.2)
        border.width: 0.5

        // Content column
        ColumnLayout {
            id: loginColumn
            anchors {
                centerIn: parent
                margins: 40
            }
            spacing: 16
            width: 240

            // User avatar placeholder
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 80
                height: 80
                radius: 40
                color: Qt.rgba(255/255, 255/255, 255/255, 0.2)
                border.color: Qt.rgba(255/255, 255/255, 255/255, 0.3)
                border.width: 1

                Image {
                    anchors.centerIn: parent
                    width: 76
                    height: 76
                    source: ""  // Will use user's face icon if available
                    fillMode: Image.PreserveAspectCrop
                    visible: source != ""

                    // Circular clip
                    layer.enabled: true
                    layer.effect: Item {} // Placeholder; real impl needs QtGraphicalEffects
                }

                // Fallback: user icon text
                Text {
                    anchors.centerIn: parent
                    text: "👤"
                    font.pixelSize: 36
                    visible: true
                }
            }

            // Username display
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: userNameField.text || defaultUser
                color: "#F5F5F7"
                font {
                    family: "Inter"
                    pixelSize: 18
                    weight: Font.DemiBold
                }
            }

            // Username field (hidden by default for single user)
            TextField {
                id: userNameField
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                placeholderText: qsTr("Username")
                text: defaultUser
                visible: userModel.count > 1
                horizontalAlignment: Text.AlignHCenter

                font {
                    family: "Inter"
                    pixelSize: 14
                }

                background: Rectangle {
                    radius: 10
                    color: Qt.rgba(255/255, 255/255, 255/255, 0.12)
                    border.color: userNameField.activeFocus ?
                        "#0066FF" : Qt.rgba(255/255, 255/255, 255/255, 0.2)
                    border.width: userNameField.activeFocus ? 2 : 0.5
                }

                color: "#F5F5F7"
                placeholderTextColor: Qt.rgba(245/255, 245/255, 247/255, 0.5)
            }

            // Password field
            TextField {
                id: passwordField
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
                horizontalAlignment: Text.AlignHCenter

                font {
                    family: "Inter"
                    pixelSize: 14
                }

                background: Rectangle {
                    radius: 10
                    color: Qt.rgba(255/255, 255/255, 255/255, 0.12)
                    border.color: passwordField.activeFocus ?
                        "#0066FF" : Qt.rgba(255/255, 255/255, 255/255, 0.2)
                    border.width: passwordField.activeFocus ? 2 : 0.5
                }

                color: "#F5F5F7"
                placeholderTextColor: Qt.rgba(245/255, 245/255, 247/255, 0.5)

                Keys.onReturnPressed: loginButton.clicked()
                Keys.onEnterPressed: loginButton.clicked()

                Component.onCompleted: forceActiveFocus()
            }

            // Error message
            Text {
                id: errorMessage
                Layout.alignment: Qt.AlignHCenter
                text: ""
                color: "#FF453A"
                font {
                    family: "Inter"
                    pixelSize: 12
                }
                visible: text !== ""
            }

            // Login button
            Button {
                id: loginButton
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                text: qsTr("Log In")

                font {
                    family: "Inter"
                    pixelSize: 14
                    weight: Font.Medium
                }

                contentItem: Text {
                    text: loginButton.text
                    font: loginButton.font
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: 10
                    color: loginButton.pressed ? "#0052CC" :
                           loginButton.hovered ? "#005CE6" : "#0066FF"

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                onClicked: {
                    errorMessage.text = ""
                    sddm.login(userNameField.text, passwordField.text, defaultSession)
                }
            }

            // Session selector (compact)
            ComboBox {
                id: sessionSelector
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 160
                model: sessionModel
                textRole: "name"
                currentIndex: defaultSession
                visible: sessionModel.count > 1

                font {
                    family: "Inter"
                    pixelSize: 12
                }

                background: Rectangle {
                    radius: 8
                    color: Qt.rgba(255/255, 255/255, 255/255, 0.08)
                    border.color: Qt.rgba(255/255, 255/255, 255/255, 0.15)
                    border.width: 0.5
                }

                contentItem: Text {
                    text: sessionSelector.displayText
                    color: Qt.rgba(245/255, 245/255, 247/255, 0.7)
                    font: sessionSelector.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onCurrentIndexChanged: {
                    root.defaultSession = currentIndex
                }
            }
        }
    }

    // Clock at bottom
    ColumnLayout {
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 48
        }
        spacing: 4

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatTime(new Date(), "h:mm")
            color: "#F5F5F7"
            font {
                family: "Inter"
                pixelSize: 64
                weight: Font.Light
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            color: Qt.rgba(245/255, 245/255, 247/255, 0.8)
            font {
                family: "Inter"
                pixelSize: 18
                weight: Font.Normal
            }
        }
    }

    // Timer for clock updates
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            // Clock texts auto-update via bindings
        }
    }

    // Handle login failure
    Connections {
        target: sddm
        function onLoginFailed() {
            errorMessage.text = qsTr("Incorrect password. Please try again.")
            passwordField.text = ""
            passwordField.forceActiveFocus()
        }
    }

    // Keyboard shortcut: power menu
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Escape) {
            // Could open power menu
        }
    }
}
