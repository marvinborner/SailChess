import QtQuick 2.0

Rectangle {
    height: this.width
    border.color: "yellow"
    border.width: 0
    MouseArea {
        anchors.fill: parent
        onClicked: parent.border.width ^= 3
    }
}
