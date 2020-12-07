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
	Words = [Modifier, Colour, "bags", "contain" | ContentsWords],
	abbreviate_rule_contents(ContentsWords, Contents),
	Rule = (Modifier, Colour, Contents).

is_separator("bag,").
is_separator("bags,").

is_terminator("bag.").
is_terminator("bags.").

abbreviate_rule_contents(["no", "other", Term | []], []) :-
	is_terminator(Term).
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

main :-
	read_lines("in/day_7.txt", Lines),
	maplist(parse_rule, Lines, Rules),
	write(Rules), nl,
	halt.

