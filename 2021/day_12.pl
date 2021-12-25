cave("start", "A").
cave("start", "b").
cave("A", "c").
cave("A", "b").
cave("b", "d").
cave("A", "end").
cave("b", "end").

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
	findall(Path, path("start", "end", Path), Paths),
	write(Paths).
