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

    function clear() {
        for (var i = 0; i < 64; i++) {
            board.itemAt(i).piece = "";
        }
    }

    property var selected: []
    function select(i) {
        if (selected.length < 2 && game_id !== "") {
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

    function convert_index(i) {
        const first = (i % 8) + 'a'.charCodeAt(0);
        const second = (7 - parseInt(i / 8)) + '1'.charCodeAt(0);
        return String.fromCharCode(first, second);
    }

    function convert_movement(movement) {
        const a = movement[0].charCodeAt(0) - 'a'.charCodeAt(0);
        const b = 8 - parseInt(movement[1])
        const c = movement[2].charCodeAt(0) - 'a'.charCodeAt(0);
        const d = 8 - parseInt(movement[3])
        return [b * 8 + a, d * 8 + c];
    }

    function move_piece(from, to) {
        if (board.itemAt(from).piece !== "") {
            board.itemAt(to).piece = board.itemAt(from).piece;
            board.itemAt(from).piece = "";
        }
    }

    function move(from, to) {
        console.log(convert_index(from) + "-" + convert_index(to));
        post("board/game/" + game_id + "/move/" + convert_index(from) + convert_index(to), "", function (response) {
            console.log(JSON.stringify(response));
            if (response["ok"])
                move_piece(from, to);
        })
        selected = [];
    }

    // END LOGIC

    property var game_id: ""
    property var moves: ""

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
                        game_stream();
                    }
                } catch (Exception) {}
            }
        };

        xhr.send();
    }

    property var game_xhr;
    function game_stream() {
        game_xhr = new XMLHttpRequest();
        game_xhr.open("GET", "https://lichess.org/api/board/game/stream/" + game_id);
        game_xhr.seenBytes = 0;
        game_xhr.setRequestHeader("Authorization", "Bearer " + access_token.value);

        game_xhr.onreadystatechange = function() {
            if (game_xhr.readyState === 3) {
                try {
                    const new_data = game_xhr.response.substr(game_xhr.seenBytes);
                    game_xhr.seenBytes = game_xhr.responseText.length;

                    console.log(new_data);
                    const data = JSON.parse(new_data);
                    var all_moves;
                    if (data["type"] === "gameFull") {
                        all_moves = data["state"]["moves"];
                    } else if (data["type"] === "gameState") {
                        all_moves = data["moves"];
                    }

                    console.log(moves);
                    console.log(all_moves);

                    const new_moves = all_moves.slice(moves.length)
                    moves += new_moves;

                    console.log(moves);

                    new_moves.split(" ").forEach(function(move) {
                        if (move !== "") {
                            const arr = convert_movement(move);
                            move_piece(arr[0], arr[1]);
                        }
                    });
                } catch (Exception) {}
            }
        };

        game_xhr.send();
    }

    function post(path, params, callback) {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "https://lichess.org/api/" + path);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("Authorization", "Bearer " + access_token.value);

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                callback(JSON.parse(xhr.responseText));
            }
        }
        xhr.send(params);
    }

    function abort() {
        post("board/game/" + game_id + "/abort", "", function (response) {
            if (response["ok"]) {
                information.text = qsTr("Please start a game");
                game_id = "";
                moves = "";
                clear();
                game_xhr.abort();
                console.log(JSON.stringify(response));
            }
        })
    }

    function challenge(username) {
        post("challenge/" + username, "rated=false&clock.limit=10800&clock.increment=60&days=14&color=white", function (response) {
            if (!response["error"]) {
                information.text = qsTr("Waiting for ") + response["challenge"]["destUser"]["name"];
                console.log(JSON.stringify(response));
            }
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
