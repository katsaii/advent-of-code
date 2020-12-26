import haxe.ds.List;
import haxe.ds.Option;

enum Turn {
	A; B;
}

typedef Deck = List<Int>;

class Main {
	static var playerA = new Deck();
	static var playerB = new Deck();
	static var turn = Turn.A;
	static var winner = false;

	static function play_turn() : Void {
		switch ({ a : playerA.first(), b : playerB.first() }) {
		case { a : null, b : _ } | { a : _, b : null }:
			winner = true;
		case { a : playA, b : playB }:
			turn = turn == Turn.A ? Turn.B : Turn.A;
			playerA.pop();
			playerB.pop();
			if (playA > playB) {
				playerA.add(playA);
				playerA.add(playB);
			} else if (playB > playA) {
				playerB.add(playB);
				playerB.add(playA);
			}
		}
	}

	static function deck_score(deck : Deck) : Int {
		var weight = deck.length;
		var score = 0;
		for (card in deck) {
			score += weight * card;
			weight -= 1;
		}
		return score;
	}

	static function main() : Void {
		playerA.add(9);
		playerA.add(2);
		playerA.add(6);
		playerA.add(3);
		playerA.add(1);
		playerB.add(5);
		playerB.add(8);
		playerB.add(4);
		playerB.add(7);
		playerB.add(10);
		while (!winner) {
			play_turn();
		}
		var winner_name = "player " + (turn == Turn.A ? "1" : "2");
		var winner_deck = turn == Turn.A ? playerA : playerB;
		Sys.println(winner_name + " is the winner");
		Sys.println(deck_score(winner_deck));
	}
}
