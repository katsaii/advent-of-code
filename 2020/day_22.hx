import sys.io.File;

enum Winner {
	A; B;
}

typedef Deck = List<Int>;

class Main {
	static function deckFromArray(arr : Array<Int>) : Deck {
		var deck = new Deck();
		for (card in arr) {
			deck.add(card);
		}
		return deck;
	}

	static function copyDeck(deck : Deck) : Deck {
		var newDeck = new Deck();
		for (card in deck) {
			newDeck.add(card);
		}
		return newDeck;
	}

	static function playCombat(playerA : Deck, playerB : Deck) : { kind : Winner, deck : Deck } {
		playerA = copyDeck(playerA);
		playerB = copyDeck(playerB);
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
		/*content = "Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10";*/
		var players = (~/\n\n/g).split(content)
				.map(function(x) return (~/\n/g).split(x)
						.map(function(x) return Std.parseInt(x))
						.filter(function(x) return x != null));
		var playerA = deckFromArray(players[0]);
		var playerB = deckFromArray(players[1]);
		var winner = playCombat(playerA, playerB);
		var score = deckScore(winner.deck);
		Sys.println("player " + (winner.kind == Winner.A ? "1" : "2") + " is the winner");
		Sys.println(score);
	}
}
