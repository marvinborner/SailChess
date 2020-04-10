import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0
import ".."

Page {
    id: page
    allowedOrientations: Orientation.Portrait

    Functions {
        id: functions
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Login")
                onClicked: {
                    access_token.value = "";
                    refresh_token.value = "";
                    pageStack.push(Qt.resolvedUrl("Login.qml"))
                }
            }
        }

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
                    id: board
                    model: 64
                    delegate: Square {
                        i: index
                    }
                }
                Component.onCompleted: functions.fill()
            }
        }
    }

    ConfigurationValue {
        id: access_token
        key: "/com/sailchess/access_token"
        defaultValue: ""
    }

    ConfigurationValue {
        id: refresh_token
        key: "/com/sailchess/refresh_token"
        defaultValue: ""
    }
}
