import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    property var name

    Column {
        width: parent.width

        DialogHeader { }

        Label {
            width: parent.width
            text: name + qsTr(" challenges you")
        }
    }
}
