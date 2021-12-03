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

abbreviate_rule(Words, Rule) :-
	Words = [Modifier, Colour, "bags", "contain" | ChildrenWords],
	abbreviate_rule_contents(ChildrenWords, Children),
	Rule = (Modifier, Colour, Children).

is_separator("bag,").
is_separator("bags,").

is_terminator("bag.").
is_terminator("bags.").

abbreviate_rule_contents(["no", "other", Term | []], []) :- is_terminator(Term).
abbreviate_rule_contents([CountAtom, Modifier, Colour, Term | []], Contents) :-
	is_terminator(Term),
	atom_number(CountAtom, Count),
	Contents = [(Count, Modifier, Colour) | []].
abbreviate_rule_contents([CountAtom, Modifier, Colour, Sep | Tail], Contents) :-
	is_separator(Sep),
	atom_number(CountAtom, Count),
	abbreviate_rule_contents(Tail, OtherContents),
	Contents = [(Count, Modifier, Colour) | OtherContents].

parse_rule(Atom, Rule) :-
	words(Atom, Words),
	abbreviate_rule(Words, Rule).

assert_rule((Modifier, Colour, Children)) :- assert_rule_contents(Modifier, Colour, Children).

assert_rule_contents(_, _, []).
assert_rule_contents(Modifier, Colour, [(Count, ChildMod, ChildCol) | Tail]) :-
	assertz(bag_contains(Modifier, Colour, Count, ChildMod, ChildCol)),
	assert_rule_contents(Modifier, Colour, Tail).

assert_rules([]).
assert_rules([X | Xs]) :-
	assert_rule(X),
	assert_rules(Xs).

bag_contains_eventually(AncestorModifier, AncestorColour, Modifier, Colour) :-
	bag_contains(AncestorModifier, AncestorColour, _, Modifier, Colour).
bag_contains_eventually(AncestorModifier, AncestorColour, Modifier, Colour) :-
	bag_contains(AncestorModifier, AncestorColour, _, ChildMod, ChildCol),
	bag_contains_eventually(ChildMod, ChildCol, Modifier, Colour).

bag_descendent_count(Modifier, Colour, N) :-
	bag_descendent_count((1, Modifier, Colour), Total),
	N is Total - 1. % ignore the root bag
bag_descendent_count((Count, Modifier, Colour), N) :-
	findall((ChildCount, ChildMod, ChildCol), bag_contains(Modifier, Colour, ChildCount, ChildMod, ChildCol), Children),
	maplist(bag_descendent_count, Children, Counts),
	foldl(plus, Counts, 1, M),
	N is Count * M.

main(_) :-
	read_lines("in/day_07.txt", Lines),
	maplist(parse_rule, Lines, Rules),
	assert_rules(Rules),
	findall((Modifier, Colour), bag_contains_eventually(Modifier, Colour, "shiny", "gold"), ContainsGoldShiny),
	sort(ContainsGoldShiny, ContainsGoldShinyDistinct),
	length(ContainsGoldShinyDistinct, ContainsGoldShinyLength),
	write("the number of bags that could contain a gold shiny bag"), nl,
	write(ContainsGoldShinyLength), nl,
	bag_descendent_count("shiny", "gold", ShinyGoldCapacity),
	nl, write("the number of individual bags required inside a gold shiny bag"), nl,
	write(ShinyGoldCapacity), nl.
