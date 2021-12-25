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

visitable(Node, _) :- is_upper(Node).
visitable(Node, Visited) :-
	\+ is_upper(Node),
	\+ member(Node, Visited).

path(Start, End, MultipleVisits, Path) :-
	path_(Start, End, MultipleVisits, [Start], Path).

path_(End, End, _, Visited, Path) :- reverse(Visited, Path).
path_(Start, End, "yes", Visited, Path) :-
	connected(Start, Next),
	\+ (Next = "start"; Next = "end"; visitable(Next, Visited)),
	path_(Next, End, "no", [Next | Visited], Path).
path_(Start, End, MultipleVisits, Visited, Path) :-
	connected(Start, Next),
	visitable(Next, Visited),
	path_(Next, End, MultipleVisits, [Next | Visited], Path).

main(_) :-
	read_caves("in/day_12.txt"),
	findall(Path, path("start", "end", "yes", Path), OncePaths),
	length(OncePaths, OnceLen),
	write("number of paths through the cave system"), nl,
	write(OnceLen), nl.
