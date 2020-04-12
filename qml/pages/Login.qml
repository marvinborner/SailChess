import QtQuick 2.2
import Sailfish.Silica 1.0
import QtWebKit 3.0
import Nemo.Configuration 1.0

Page {
    SilicaWebView {
        property real device_ratio: Math.round(1.5 * Theme.pixelRatio * 10) / 10.0

        id: login
        anchors.fill: parent
        experimental.preferences.javascriptEnabled: true
        experimental.userStyleSheets: [Qt.resolvedUrl("qrc:///css/external.css")]
        // experimental.preferences.privateBrowsingEnabled: true
        experimental.customLayoutWidth: parent.width / device_ratio
        url: "https://marvinborner.de/lichess/"

        onNavigationRequested: {
            if (request.url.toString().lastIndexOf("https://marvinborner.de/lichess/callback", 0) === 0) {
                request.action = WebView.IgnoreRequest;

                var xhr = new XMLHttpRequest();
                xhr.open("GET", request.url, false);
                xhr.send();
                if (xhr.status === 200) {
                    const data = JSON.parse(xhr.responseText);
                    access_token.value = data["access_token"];
                    refresh_token.value = data["refresh_token"];
                    pageStack.push(Qt.resolvedUrl("Board.qml"))
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
}
