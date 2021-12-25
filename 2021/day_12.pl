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

visitableOnce(Node, Visited) :-
	string_chars(Node, [Fst | _]),
	char_type(Fst, lower),
	memberchk(Node, Visited).

path(Start, End, Pred, Path) :- path_(Start, End, Pred, [Start], Path).

path_(End, End, _, Visited, Path) :- reverse(Visited, Path).
path_(Start, End, Pred, Visited, Path) :-
	connected(Start, Next),
	\+ call(Pred, Next, Visited),
	path_(Next, End, Pred, [Next | Visited], Path).

main(_) :-
	read_caves("in/day_12.txt"),
	findall(Path, path("start", "end", visitableOnce, Path), Paths),
	length(Paths, Len),
	write("number of paths out of the cave system"), nl,
	write(Len), nl.
