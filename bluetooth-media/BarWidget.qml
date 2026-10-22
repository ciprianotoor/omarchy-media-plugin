import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
import qs.Ui
import qs.Commons

BarWidget {
  id: root
  moduleName: "cipriano.bluetooth-media"
  readonly property var devices: Bluetooth.devices ? Bluetooth.devices.values : []
  readonly property var connectedDevice: {
    for (var i = 0; i < devices.length; i++)
      if (devices[i] && devices[i].connected) return devices[i]
    return null
  }
  property bool popupOpen: false
  property string playerObjectPath: ""
  property bool avrcpChecked: false

  function close() { popupOpen = false }
  function scanAvrcp() {
    playerObjectPath = ""
    avrcpChecked = false
    var address = connectedDevice && connectedDevice.address
      ? String(connectedDevice.address).replace(/:/g, "_") : ""
    if (!address) { avrcpChecked = true; return }
    avrcpScan.command = ["busctl", "tree", "org.bluez", "/org/bluez/hci0/dev_" + address]
    avrcpScan.running = true
  }
  function send(method) {
    if (!playerObjectPath) return
    Quickshell.execDetached(["gdbus", "call", "--system", "--dest", "org.bluez",
      "--object-path", playerObjectPath, "--method", "org.bluez.MediaPlayer1." + method])
  }
  function openBluetoothPanel() {
    Quickshell.execDetached(["omarchy-shell", "omarchy.bluetooth", "toggle"])
  }

  visible: true
  implicitWidth: Style.space(34)
  implicitHeight: barSize

  Text {
    anchors.centerIn: parent
    text: "󰎆"
    color: "#4da3ff"
    font.family: root.bar.fontFamily
    font.pixelSize: Style.font.body
  }
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: function(mouse) {
      if (mouse.button === Qt.RightButton) root.openBluetoothPanel()
      else root.popupOpen = !root.popupOpen
    }
  }

  PopupCard {
    id: popup
    anchorItem: root
    bar: root.bar
    owner: root
    open: root.popupOpen
    contentWidth: popup.fittedContentWidth(Style.space(270))
    contentHeight: popup.fittedContentHeight(column.implicitHeight)

    Column {
      id: column
      anchors.fill: parent
      spacing: Style.space(10)

      Text {
        text: "Bluetooth Media"
        color: root.bar.foreground
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.subtitle
        font.bold: true
      }
      Text {
        text: root.connectedDevice ? (root.connectedDevice.name || "Dispositivo conectado") : "Sin dispositivo Bluetooth conectado"
        color: Qt.darker(root.bar.foreground, 1.4)
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.caption
        width: parent.width
        elide: Text.ElideRight
      }
      PanelSeparator { foreground: root.bar.foreground }
      Text {
        width: parent.width
        text: !root.avrcpChecked ? "Comprobando compatibilidad multimedia…"
          : (root.playerObjectPath ? "Control multimedia disponible" : "Dispositivo no compatible con control multimedia")
        color: !root.avrcpChecked ? "#ffcc66" : (root.playerObjectPath ? root.bar.foreground : "#ff4d4d")
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.caption
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
      }
      Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Style.space(6)
        Button { enabled: !!root.playerObjectPath; iconText: "󰒮"; foreground: root.bar.foreground; onClicked: root.send("Previous") }
        Button { enabled: !!root.playerObjectPath; iconText: "󰐊"; foreground: root.bar.foreground; onClicked: root.send("Play") }
        Button { enabled: !!root.playerObjectPath; iconText: "󰏤"; foreground: root.bar.foreground; onClicked: root.send("Pause") }
        Button { enabled: !!root.playerObjectPath; iconText: "󰒭"; foreground: root.bar.foreground; onClicked: root.send("Next") }
      }
      Button {
        width: parent.width
        iconText: "󰂯"
        text: "Administrar conexión"
        foreground: "#ffd54a"
        onClicked: root.openBluetoothPanel()
      }
    }
  }

  Process {
    id: avrcpScan
    running: false
    stdout: SplitParser {
      onRead: function(line) {
        var match = String(line).match(/(\/org\/bluez\/\S+\/player\S*)/)
        if (match && match[1]) root.playerObjectPath = match[1]
      }
    }
    onExited: root.avrcpChecked = true
  }
  Connections {
    target: root
    function onConnectedDeviceChanged() { root.scanAvrcp() }
    function onPopupOpenChanged() { if (root.popupOpen) root.scanAvrcp() }
  }
}
