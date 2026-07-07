import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.Services

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: root

	required property var modelData
        screen: modelData
    
        /* ================= THEME ================= */
        property color colBg: "#1a1b26"
        property color colFg: "#a9b1d6"
        property color colMuted: "#444b6a"
        property color colCyan: "#0db9d7"
        property color colBlue: "#7aa2f7"
        property color colYellow: "#e0af68"
        property string fontFamily: "JetBrainsMono Nerd Font"
        property int fontSize: 14
    
        /* ================= SYSTEM DATA ================= */
        property int cpuUsage: 0
        property int memUsage: 0
        property int batteryLevel: 0
        property var lastCpuIdle: 0
        property var lastCpuTotal: 0
    
        /* ================= BATTERY ICON HELPER ================= */
        property string batteryIcon: {
            if (batteryLevel >= 90) return "󰁹"
            if (batteryLevel >= 70) return "󰂀"
            if (batteryLevel >= 50) return "󰁾"
            if (batteryLevel >= 30) return "󰁼"
            if (batteryLevel >= 10) return "󰁺"
            return "󰂃"
        }
    
        /* ================= CPU ================= */
        Process {
            id: cpuProc
            command: ["sh", "-c", "head -1 /proc/stat"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    const p = data.trim().split(/\s+/)
                    const idle = Number(p[4]) + Number(p[5])
                    const total = p.slice(1).reduce((a, b) => a + Number(b), 0)
                    if (lastCpuTotal > 0 && total > lastCpuTotal) {
                        cpuUsage = Math.round(
                            100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal))
                        )
                    }
                    lastCpuIdle = idle
                    lastCpuTotal = total
                }
            }
            Component.onCompleted: running = true
        }
    
        /* ================= MEMORY ================= */
        Process {
            id: memProc
            command: ["sh", "-c", "free | awk '/Mem:/ {print int($3*100/$2)}'"]
            stdout: SplitParser { onRead: data => memUsage = parseInt(data) || 0 }
            Component.onCompleted: running = true
        }
    
        /* ================= BATTERY ================= */
        Process {
            id: batProc
            command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null"]
            stdout: SplitParser { onRead: data => batteryLevel = parseInt(data) || 0 }
            Component.onCompleted: running = true
        }
    
        /* ================= UPDATE TIMER ================= */
        Timer {
            interval: 2000
            running: true
            repeat: true
            onTriggered: {
                cpuProc.running = true
                memProc.running = true
                batProc.running = true
            }
        }
    
        anchors {
            top: true
            left: true
            right: true
        }
    
        implicitHeight: 30
        color: root.colBg
    
        /* ================= LAYOUT ================= */
        RowLayout {
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.bottomMargin: 8
            anchors.leftMargin: 20
            anchors.rightMargin: 20 
            spacing: 12
    
            /* ---------- LEFT: CLOCK & DATE ---------- */
            RowLayout { 
                spacing: 6
    
                Text {
                    id: clock
                    text: Qt.formatDateTime(new Date(), "ddd,")
                    color: root.colBlue
                    font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
    
                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd,")
                    }
                }
    
                // Rectangle { width: 1; height: 16; color: root.colMuted }
    
                Text {
                    id: date
                    text: Qt.formatDateTime(new Date(), "MMM dd - HH:mm")
                    color: root.colBlue
                    font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
    
                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: date.text = Qt.formatDateTime(new Date(), "MMM dd - HH:mm")
                    }
                }
            }
    
            /* ---------- SPACER ---------- */
            Item { Layout.fillWidth: true }
    
            /* ---------- CENTER: WORKSPACES ---------- */
            RowLayout {
                spacing: 8
                Layout.alignment: Qt.AlignHCenter
	    
                Repeater {
                    model: NiriService.allWorkspaces.filter(ws => ws.output == root.screen.name)
                    Text {
                        property var wsData: modelData
			property bool notEmpty: NiriService.windows.some(
                            w => w.workspace_id === wsData.id
                        )
                        text: wsData.idx
                        font { family: fontFamily; pixelSize: fontSize; bold: true }
    
			color: wsData.is_focused ? "#f7768e" : notEmpty ? colCyan : colMuted
    
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                NiriService.switchToWorkspace(wsData.idx)
                            }
                        }
                    }
                }
            }
    
            /* ---------- SPACER ---------- */
            Item { Layout.fillWidth: true }
    
            /* ---------- RIGHT: BATTERY, MEMORY, CPU ---------- */
            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignRight
    
                Text {
                    text: "CPU " + cpuUsage + "%"
                    color: root.colYellow
                    font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                }
    
                Rectangle { width: 1; height: 16; color: root.colMuted }
    
                Text {
                    text: "MEM " + memUsage + "%"
                    color: root.colCyan
                    font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                }
    
                Rectangle { width: 1; height: 16; color: root.colMuted }
    
                Text {
                    text: batteryIcon + " " + batteryLevel + "%"
                    color: batteryLevel < 15 ? "#f7768e" : root.colBlue
                    font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                }
            }
        }
    }
}
