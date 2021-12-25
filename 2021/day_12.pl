:- dynamic cave/2.

read_caves(Path) :-
	open(Path, read, Stream),
	read_caves_(Stream),
	close(Stream).

read_caves_(Stream) :- at_end_of_stream(Stream).
read_caves_(Stream) :-
	read_line_to_codes(Stream, Codes),
	read_caves_(Stream),
	atom_codes(Line, Codes),
	split_string(Line, "-", "", [Start, End]),
	assertz(cave(Start, End)).

connected(X, Y) :- cave(X, Y).
connected(X, Y) :- cave(Y, X).

visitable(Node, Visited) :-
	string_chars(Node, [Fst | _]),
	char_type(Fst, lower),
	memberchk(Node, Visited).

path(Start, End, Path) :- path_(Start, End, [Start], Path).

path_(End, End, Visited, Path) :- reverse(Visited, Path).
path_(Start, End, Visited, Path) :-
	connected(Start, Next),
	\+ visitable(Next, Visited),
	path_(Next, End, [Next | Visited], Path).

main(_) :-
	read_caves("in/day_12.txt"),
	findall(Path, path("start", "end", Path), Paths),
	length(Paths, Len),
	write("number of paths out of the cave system"), nl,
	write(Len), nl.
