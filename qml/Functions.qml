import QtQuick 2.0
import "pages"

Item {
    id: functions

    function get_piece(i) {
        if (i === 0 || i === 7) return "r";
        else if (i === 1 || i === 6) return "n";
        else if (i === 2 || i === 5) return "b";
        else if (i === 3) return "q";
        else if (i === 4) return "k";
        else if (i >= 8 && i <= 15) return "p";
    }

    function fill() {
        for (var i = 0; i < 16; i++) {
            const piece = get_piece(i);

            board.itemAt(i).piece = "b" + piece;
            board.itemAt(-i + 63).piece = "w" + piece;
        }
        // Swap white king & queen
        board.itemAt(60).piece = [board.itemAt(59).piece, board.itemAt(59).piece = board.itemAt(60).piece][0];
    }

    property var selected: []
    function select(i) {
        if (selected.length < 2) {
            if (selected.indexOf(i) === -1) selected.push(i)
            else selected.splice(selected.indexOf(i), 1)

            if (selected.length === 2) {
                board.itemAt(selected[0]).border.width = 0;
                move(selected[0], selected[1]);
            } else {
                board.itemAt(i).border.width ^= parseInt(0.1 * board.itemAt(i).width);
            }
        }
    }

    function convert(i) {
        const first = (i % 8) + 'a'.charCodeAt(0);
        const second = (7 - parseInt(i / 8)) + '1'.charCodeAt(0);
        return String.fromCharCode(first, second);
    }

    function move(from, to) {
        console.log(convert(from) + "-" + convert(to));
        board.itemAt(to).piece = board.itemAt(from).piece;
        board.itemAt(from).piece = "";
        selected = [];
    }

    // END LOGIC

    property var game_id: ""

    function event_stream() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "https://lichess.org/api/stream/event");
        xhr.seenBytes = 0;
        xhr.setRequestHeader("Authorization", "Bearer " + access_token.value);

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 3) {
                try {
                    const new_data = xhr.response.substr(xhr.seenBytes);
                    xhr.seenBytes = xhr.responseText.length;

                    console.log(new_data);
                    const data = JSON.parse(new_data);
                    if (data["type"] === "gameStart") {
                        information.text = qsTr("Game started!");
                        fill();
                        game_id = data["game"]["id"];
                    }
                } catch (Exception) {}
            }
        };

        xhr.send();
    }

    function post(path, params, callback) {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "https://lichess.org/api/" + path);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("Authorization", "Bearer " + access_token.value);

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                callback(JSON.parse(xhr.responseText));
            } else if (xhr.readyState === 4) {
                console.error(xhr.responseText);
            }
        }
        xhr.send(params);
    }

    function challenge(username) {
        post("challenge/" + username, "rated=false&clock.limit=10800&clock.increment=60&days=14&color=white", function (response) {
            information.text = qsTr("Challenging ") + response["challenge"]["destUser"]["name"];
            console.log(JSON.stringify(response));
        });
    }

    function start_seek() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "https://lichess.org/api/account");
        xhr.setRequestHeader("Authorization", "Bearer " + access_token.value);

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 3) {
                console.log(xhr.responseText);
            }
        };

        xhr.send();
    }
}
