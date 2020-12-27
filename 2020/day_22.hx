import sys.io.File;

enum Winner {
	A; B;
}

typedef Deck = List<Int>;
typedef GameResult = { kind : Winner, deck : Deck };

class Main {
	static function deckFromArray(arr : Array<Int>) : Deck {
		var deck = new Deck();
		for (card in arr) {
			deck.add(card);
		}
		return deck;
	}

	static function sliceDeck(deck : Deck, count : Int) : Deck {
		var newDeck = new Deck();
		var i = 0;
		for (card in deck) {
			if (i >= count) {
				break;
			}
			i += 1;
			newDeck.add(card);
		}
		return newDeck;
	}

	static function playCombat(playerA : Deck, playerB : Deck) : GameResult {
		while (true) {
			if (playerA.length == 0) {
				return { kind : Winner.B, deck : playerB };
			} else if (playerB.length == 0) {
				return { kind : Winner.A, deck : playerA };
			}
			var playA = playerA.pop();
			var playB = playerB.pop();
			if (playA > playB) {
				playerA.add(playA);
				playerA.add(playB);
			} else if (playB > playA) {
				playerB.add(playB);
				playerB.add(playA);
			}
		}
	}

	static function playRecursiveCombat(playerA : Deck, playerB : Deck) : GameResult {
		var visitedDecks = new Map<String, Bool>();
		while (true) {
			if (playerA.length == 0) {
				return { kind : Winner.B, deck : playerB };
			} else if (playerB.length == 0) {
				return { kind : Winner.A, deck : playerA };
			}
			var keyA = Std.string(playerA);
			var keyB = Std.string(playerB);
			if (visitedDecks.exists(keyA) && visitedDecks.exists(keyB)) {
				// stop infinite games
				return { kind : Winner.A, deck : playerA };
			}
			visitedDecks.set(keyA, true);
			visitedDecks.set(keyB, true);
			var playA = playerA.pop();
			var playB = playerB.pop();
			var winner = null;
			if (playerA.length >= playA && playerB.length >= playB) {
				winner = playRecursiveCombat(
						sliceDeck(playerA, playA),
						sliceDeck(playerB, playB)).kind;
			} else if (playA > playB) {
				winner = Winner.A;
			} else if (playB > playA) {
				winner = Winner.B;
			}
			switch (winner) {
			case Winner.A:
				playerA.add(playA);
				playerA.add(playB);
			case Winner.B:
				playerB.add(playB);
				playerB.add(playA);
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
	static function main() : Void {
		var content = File.getContent("in/day_22.txt");
		var players = (~/\n\n/g).split(content)
				.map(function(x) return (~/\n/g).split(x)
						.map(function(x) return Std.parseInt(x))
						.filter(function(x) return x != null));
		var combatWinner = playCombat(
				deckFromArray(players[0]),
				deckFromArray(players[1]));
		var recursiveCombatWinner = playRecursiveCombat(
				deckFromArray(players[0]),
				deckFromArray(players[1]));
		Sys.println("player " + (combatWinner.kind == Winner.A ? "1" : "2") + " is the combat winner");
		Sys.println(deckScore(combatWinner.deck));
		Sys.println("\nplayer " + (recursiveCombatWinner.kind == Winner.A ? "1" : "2") + " is the recursive combat winner");
		Sys.println(deckScore(recursiveCombatWinner.deck));
	}
}
