import sys.io.File;

enum Turn {
	A; B;
}

typedef Deck = List<Int>;

class Main {
	static var playerA = new Deck();
	static var playerB = new Deck();
	static var turn = Turn.A;
	static var winner = false;

	static function playTurn() : Void {
		if (playerA.length == 0) {
			turn = Turn.B;
			winner = true;
		} else if (playerB.length == 0) {
			turn = Turn.A;
			winner = true;
		} else {
			var playA = playerA.pop();
			var playB = playerB.pop();
			if (playA > playB) {
				playerA.add(playA);
				playerA.add(playB);
			} else if (playB > playA) {
				playerB.add(playB);
				playerB.add(playA);
			}
			turn = turn == Turn.A ? Turn.B : Turn.A;
		}
	}

	static function deckScore(deck : Deck) : Int {
		var weight = deck.length;
		var score = 0;
		for (card in deck) {
			score += weight * card;
			weight -= 1;
		}
		return score;
	}

	static function main() : Void {
		var content = File.getContent("in/day_22.txt");
		var players = (~/\n\n/g).split(content)
				.map(function(x) return (~/\n/g).split(x)
						.map(function(x) return Std.parseInt(x))
						.filter(function(x) return x != null));
		for (card in players[0]) {
			playerA.add(card);
		}
		for (card in players[1]) {
			playerB.add(card);
		}
		while (!winner) {
			playTurn();
		}
		var winnerName = "player " + (turn == Turn.A ? "1" : "2");
		var winnerDeck = turn == Turn.A ? playerA : playerB;
		Sys.println(winnerName + " is the winner");
		Sys.println(deckScore(winnerDeck));
	}
}
