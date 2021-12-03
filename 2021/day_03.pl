:- use_module(library(clpfd)).

read_samples(Path, Lines) :-
	open(Path, read, Stream),
	read_samples_(Stream, Lines),
	close(Stream).

read_samples_(Stream, []) :- at_end_of_stream(Stream).
read_samples_(Stream, [X | Xs]) :-
	read_line_to_codes(Stream, Codes),
	read_samples_(Stream, Xs),
	maplist(plus(-48), Codes, X).

greater_than(A, B, 1) :- A >= B.
greater_than(_, _, 0).

flip_bit(0, 1).
flip_bit(1, 0).

majority_sample(Samples, Major) :-
	length(Samples, Length),
	sum_list(Samples, Count),
	greater_than(Count * 2, Length, Major).

bits_to_number([], 0).
bits_to_number(Xs, N) :-
	bits_to_number_(Xs, N, _).

bits_to_number_([X | []], X, 2).
bits_to_number_([X | Xs], OutN, OutUnit) :-
	bits_to_number_(Xs, N, Unit),
	OutN is N + Unit * X,
	OutUnit is 2 * Unit.

match_length([X | Xs], [Y | Ys], N) :-
	X = Y,
	match_length(Xs, Ys, M),
	N is M + 1.
match_length(_, _, 0).

choose_best(A, Aw, _, Bw, A, Aw) :- Aw > Bw.
choose_best(_, _, B, Bw, B, Bw).

find_best_match(Criteria, Samples, BestMatch) :-
	find_best_match_(Criteria, Samples, [], 0, BestMatch).

find_best_match_(_, [], BestMatch, _, BestMatch).
find_best_match_(Criteria, [X | Xs], PrevMatch, PrevWeight, BestMatch) :-
	match_length(Criteria, X, NewWeight),
	choose_best(PrevMatch, PrevWeight, X, NewWeight, NewBestMatch, NewBestWeight),
	find_best_match_(Criteria, Xs, NewBestMatch, NewBestWeight, BestMatch).

main(_) :-
	read_samples("./in/day_03.txt", Rows),
	transpose(Rows, Columns),
	maplist(majority_sample, Columns, GammaRateBits),
	maplist(flip_bit, GammaRateBits, EpsilonRateBits),
	find_best_match(GammaRateBits, Rows, O2RatingBits),
	find_best_match(EpsilonRateBits, Rows, CO2RatingBits),
	bits_to_number(GammaRateBits, GammaRate),
	bits_to_number(EpsilonRateBits, EpsilonRate),
	bits_to_number(O2RatingBits, O2Rating),
	bits_to_number(CO2RatingBits, CO2Rating),
	PowerConsumption is GammaRate * EpsilonRate,
	LifeSupportRating is O2Rating * CO2Rating,
	write("power consumption of the submarine"), nl,
	write(PowerConsumption), nl, nl,
	write(O2RatingBits), nl,
	write(CO2RatingBits), nl,
	write("life support rating"), nl,
	write(LifeSupportRating), nl.
