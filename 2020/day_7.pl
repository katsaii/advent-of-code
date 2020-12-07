:- dynamic bag_contains/5.

read_lines(Path, Lines) :-
	open(Path, read, Stream),
	read_stream_to_codes(Stream, Codes),
	close(Stream),
	atom_codes(Content, Codes),
	Newline = "\r\n",
	split_string(Content, Newline, Newline, Lines).

words(Atom, Words) :-
	Space = "\s\t\r\n",
	split_string(Atom, Space, Space, Words).

abbreviate_rule(Long, Short) :-
	Long = [Modifier, Colour, "bags", "contain", Number, InnerMod, InnerCol, "bags." | []],
	Short = (Modifier, Colour, [(Number, InnerMod, InnerCol) | []]).

main :-
	read_lines("in/day_7.txt", Lines),
	maplist(words, Lines, Rules),
	maplist(abbreviate_rule, Rules, AbbrRules),
	write(AbbrRules), nl,
	halt.

/*
:- dynamic mother/2.

grandmother(X, Y) :-
	mother(X, Someone),
	mother(Someone, Y).

grandchildren(Grandmother, Grandchildren) :-
	findall(Grandchild, grandmother(Grandmother, Grandchild), Grandchildren).

main :-
	assert(mother(alice, lisa)),
	assert(mother(lisa, kate)),
	assert(mother(lisa, bob)),
	assert(mother(lisa, frank)),
	grandchildren(alice, Xs),
	write(Xs), nl,
	halt.
*/
