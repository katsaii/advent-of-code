:- use_module(library(clpfd)).

read_samples(Path, Lines) :-
	open(Path, read, Stream),
	read_samples_(Stream, Lines),
	close(Stream).

read_samples_(Stream, []) :-
	at_end_of_stream(Stream).

read_samples_(Stream, [X | XS]) :-
	read_line_to_codes(Stream, Codes),
	read_samples_(Stream, XS),
	maplist(plus(-48), Codes, X).

greater_than(A, B, 0) :- A > B.
greater_than(_, _, 1).

flip_bit(0, 1).
flip_bit(1, 0).

majority_sample(Samples, Major) :-
	length(Samples, Length),
	sum_list(Samples, Count),
	greater_than(Length, Count * 2, Major).

bits_to_number([], 0).
bits_to_number(XS, N) :-
	bits_to_number_(XS, N, _).

bits_to_number_([X | []], X, 2).
bits_to_number_([X | XS], OutN, OutUnit) :-
	bits_to_number_(XS, N, Unit),
	OutN is N + Unit * X,
	OutUnit is 2 * Unit.

main(_) :-
	read_samples("./in/day_03.txt", Rows),
	transpose(Rows, Columns),
	maplist(majority_sample, Columns, GammaRateBits),
	maplist(flip_bit, GammaRateBits, EpsilonRateBits),
	bits_to_number(GammaRateBits, GammaRate),
	bits_to_number(EpsilonRateBits, EpsilonRate),
	PowerConsumption is GammaRate * EpsilonRate,
	write("power consumption of the submarine"), nl,
	write(PowerConsumption), nl.
