import sys.io.File;

enum Turn {
	A; B;
}

typedef Deck = List<Int>;

class Main {
	static var playerA = new Deck();
	static var playerB = new Deck();
	static var seenCombosA = new Map<Deck, Bool>();
	static var seenCombosB = new Map<Deck, Bool>();

	static function playTurn(turn : Turn) : Turn {
		if (playerA.length == 0) {
			return Turn.B;
		} else if (playerB.length == 0) {
			return Turn.A;
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
			return playTurn(turn == Turn.A ? Turn.B : Turn.A);
		}
	}

	static function playTurnRecursive() : Void {
		if (seenCombosA.exists(playerA) && seenCombosB.exists(playerB)) {
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
		var winner = playTurn(Turn.A);
		var winnerName = "player " + (winner == Turn.A ? "1" : "2");
		var winnerDeck = winner == Turn.A ? playerA : playerB;
		Sys.println(winnerName + " is the winner");
		Sys.println(deckScore(winnerDeck));
	}
}
