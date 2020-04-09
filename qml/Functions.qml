import QtQuick 2.0
import "pages"

Item {
    id: functions

    function get_piece(i) {
        if (i === 0 || i === 7) return "rook";
        else if (i === 1 || i === 6) return "knight";
        else if (i === 2 || i === 5) return "bishop";
        else if (i === 3) return "queen";
        else if (i === 4) return "king";
        else if (i >= 8 && i <= 15) return "pawn";
    }

    function fill() {
        for (var i = 0; i < 16; i++) {
            const piece = get_piece(i);
            repeater.itemAt(i).image = piece !== "" ? "images/b" + piece + ".svg" : "";
            repeater.itemAt(-i + 63).image = piece !== "" ? "images/w" + piece + ".svg" : "";
        }
        // Swap white king & queen
        repeater.itemAt(60).image = [repeater.itemAt(59).image, repeater.itemAt(59).image = repeater.itemAt(60).image][0];
    }
}
