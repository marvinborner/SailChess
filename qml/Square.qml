import QtQuick 2.0

Rectangle {
    property int i: 0
    property string image: ""
    width: page.width / 8
    height: this.width
    color: ((i >> 3 ^ i) & 1) == 1 ? "#e8ebef" : "#7d8796"
    border.color: "yellow"
    border.width: 0
    MouseArea {
        anchors.fill: parent
        onClicked: parent.border.width ^= 3
    }
    Image {
        width: parent.width
        height: this.width
        source: image
    }
}
