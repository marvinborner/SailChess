import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: page
    allowedOrientations: Orientation.Portrait

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            height: page.height
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Chess")
            }

            Grid {
                property int row: 0

                id: grid
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                columns: 8
                rows: 8
                Repeater {
                    id: repeater
                    model: 64
                    delegate: Square {
                        width: page.width / 8
                        color: ((index >> 3 ^ index) & 1) == 1 ? "#e8ebef" : "#7d8796"

                    }
                }
            }
        }
    }
}
