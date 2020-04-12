import QtQuick 2.2
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "pages"

ApplicationWindow
{
    initialPage: Qt.resolvedUrl(access_token.value === "" ? "pages/Login.qml" : "pages/Board.qml")
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.Portrait

    ConfigurationValue {
        id: access_token
        key: "/com/sailchess/access_token"
        defaultValue: ""
    }
}
