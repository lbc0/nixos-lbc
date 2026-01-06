import Quickshell
import Quickshell.Io
import QtQuick
import qs.Theme
import qs.Bar.Modules

Variants {
    model: Quickshell.screens

    PanelWindow {
        color: Theme.bg
        id: bar

        required property var modelData
        screen: modelData

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 36

        Item {
            id: barTop

            property int horizontalPadding: 20

            anchors.fill: parent
            anchors.verticalCenter: parent.verticalCenter

            children: [
                Row {
                    anchors.horizontalCenter: barTop.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    children: [
                        Niri {}
                    ]
                },
                Row {
                    anchors.right: barTop.right
                    anchors.verticalCenter: parent.verticalCenter
                    rightPadding: barTop.horizontalPadding

                    spacing: 8

                    children: [
                        Battery {}
                    ]
                },
                Row {
                    anchors.left: barTop.left
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: barTop.horizontalPadding

                    spacing: 8

                    children: [
                        Clock {}
                    ]
                }
            ]
        }
    }
}
