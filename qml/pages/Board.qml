import QtQuick 2.2
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
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
                text: qsTr("Challenge user")
                visible: functions.game_id === "" ? true : false
                onClicked: {
                    var dialog = pageStack.push("UserDialog.qml");
                    dialog.accepted.connect(function() {
                        functions.challenge(dialog.name);
                    });
                }
            }
            MenuItem {
                // I THINK it works like that
                text: qsTr("Abort game")
                visible: functions.game_id !== "" && functions.moves.split(" ").length <= 2 ? true : false
                onClicked: functions.abort()
            }
            MenuItem {
                text: qsTr("Resign game")
                visible: functions.game_id !== "" && functions.moves.split(" ").length > 2 ? true : false
                onClicked: functions.resign()
            }
            MenuItem {
                text: qsTr("Offer/accept draw")
                visible: functions.game_id !== "" && functions.moves.split(" ").length > 2 ? true : false
                onClicked: functions.offer_draw()
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

            LinkedLabel {
                id: information
                width: parent.width
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: grid.top
                bottomPadding: Theme.paddingMedium
                plainText: qsTr("Please start a game");
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
                id: turn_label
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: grid.bottom
                topPadding: Theme.paddingMedium
                text: functions.turn ? qsTr("Your turn") : qsTr("Opponents turn");
            }

            LinkedLabel {
                id: chat
                width: parent.width
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: turn_label.bottom
                topPadding: Theme.paddingMedium
                plainText: "";
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
