import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    property var name

    Column {
        width: parent.width

        DialogHeader { }

        TextField {
            id: username
            width: parent.width
            placeholderText: qsTr("e.g. LeelaChess")
            label: qsTr("Username")
        }
    }

    onDone: {
         if (result == DialogResult.Accepted) {
             name = username.text;
         }
     }
}
