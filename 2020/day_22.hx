import sys.io.File;

enum Winner {
	A; B;
}

typedef Deck = List<Int>;

class Main {
	static var playerA = new Deck();
	static var playerB = new Deck();
	static var seenCombosA = new Map<String, Bool>();
	static var seenCombosB = new Map<String, Bool>();

	static function playCombat() : Winner {
		if (playerA.length == 0) {
			return Winner.B;
		} else if (playerB.length == 0) {
			return Winner.A;
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
			return playCombat();
		}
	}

	static function playCombatRecursive() : Winner {
		if (playerA.length == 0) {
			return Winner.B;
		} else if (playerB.length == 0) {
			return Winner.A;
		} else {
			var keyA = Std.string(playerA);
			var keyB = Std.string(playerB);
			if (seenCombosA.exists(keyA) && seenCombosB.exists(keyB)) {
				return Winner.A;
			}
			Sys.println("Player 1's deck: " + playerA);
			Sys.println("Player 2's deck: " + playerB);
			seenCombosA.set(keyA, true);
			seenCombosB.set(keyB, true);
			var playA = playerA.pop();
			var playB = playerB.pop();
			if (playerA.length < playA && playerB.length < playB) {
				return playCombatRecursive();
			} else {
				if (playA > playB) {
					playerA.add(playA);
					playerA.add(playB);
				} else if (playB > playA) {
					playerB.add(playB);
					playerB.add(playA);
				}
				return playCombatRecursive();
			}
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

	static function populateDecks(players : Array<Array<Int>>) : Void {
		playerA.clear();
		playerB.clear();
		for (card in players[0]) {
			playerA.add(card);
		}
		for (card in players[1]) {
			playerB.add(card);
		}
	}

	static function main() : Void {
		var content = File.getContent("in/day_22.txt");
		content = "Player 1:
43
19

Player 2:
2
29
14";
		var players = (~/\n\n/g).split(content)
				.map(function(x) return (~/\n/g).split(x)
						.map(function(x) return Std.parseInt(x))
						.filter(function(x) return x != null));
		populateDecks(players);
		var winner = playCombat();
		var score = deckScore(winner == Winner.A ? playerA : playerB);
		populateDecks(players);
		var winner2 = playCombatRecursive();
		var score2 = deckScore(winner2 == Winner.A ? playerA : playerB);
		Sys.println("player " + (winner == Winner.A ? "1" : "2") + " is the winner");
		Sys.println(score);
		Sys.println("\nplayer " + (winner2 == Winner.A ? "1" : "2") + " is the winner");
		Sys.println(score2);
	}
}
