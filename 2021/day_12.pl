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

is_upper(X) :-
	string_chars(X, [Fst | _]),
	char_type(Fst, upper).

visitable(Node, _, _) :- is_upper(Node).
visitable(Node, Pred, Visited) :-
	\+ is_upper(Node),
	call(Pred, Node, Visited).

path(Start, End, Pred, Path) :- path_(Start, End, Pred, [Start], Path).

path_(End, End, _, Visited, Path) :- reverse(Visited, Path).
path_(Start, End, Pred, Visited, Path) :-
	connected(Start, Next),
	visitable(Next, Pred, Visited),
	path_(Next, End, Pred, [Next | Visited], Path).

enterOnce(Node, Visited) :- \+ member(Node, Visited).

main(_) :-
	read_caves("in/day_12.txt"),
	findall(Path, path("start", "end", enterOnce, Path), OncePaths),
	length(OncePaths, OnceLen),
	write("number of paths through the cave system"), nl,
	write(OnceLen), nl.
