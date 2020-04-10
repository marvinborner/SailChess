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
                text: qsTr("Refresh login")
                onClicked: {
                    access_token.value = "";
                    refresh_token.value = "";
                    pageStack.push(Qt.resolvedUrl("Login.qml"))
                }
            }
            MenuItem {
                text: qsTr("Random player")
                visible: functions.game_id === "" ? true : false
                onClicked: functions.start_seek()
            }
            MenuItem {
                text: qsTr("Play against bot")
                visible: functions.game_id === "" ? true : false
                onClicked: functions.challenge("awesomelvin")
            }
            MenuItem {
                text: qsTr("Abort game")
                visible: functions.game_id === "" ? false : true
                onClicked: functions.abort()
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

            Label {
                id: information
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: grid.top
                bottomPadding: Theme.paddingMedium
                text: qsTr("Please start a game");
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
                Component.onCompleted: {
                    functions.event_stream();
                }
            }

            Label {
                // id: turn_label
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: grid.bottom
                topPadding: Theme.paddingMedium
                text: functions.turn ? qsTr("Your turn") : qsTr("Opponents turn");
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
