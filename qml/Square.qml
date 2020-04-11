import QtQuick 2.2

Rectangle {
    property int i: 0
    property string piece: ""
    property string image: piece !== "" ? "qrc:///images/" + piece + ".svg" : ""

    width: page.width / 8
    height: this.width
    color: ((i >> 3 ^ i) & 1) == 0 ? "#e8ebef" : "#7d8796"
    border.color: "yellow"
    border.width: 0

    MouseArea {
        anchors.fill: parent
        onClicked: functions.select(i);
    }
    Image {
        id: piece_image
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        source: image
    }
}
