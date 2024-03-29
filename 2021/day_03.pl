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

keep_bit(Bit, Bit).

majority_sample(Mapping, Samples, Major) :-
	length(Samples, Length),
	sum_list(Samples, Count),
	greater_than(Count * 2, Length, Greater),
	call(Mapping, Greater, Major).

bits_to_number([], 0).
bits_to_number(Xs, N) :-
	bits_to_number_(Xs, N, _).

bits_to_number_([X | []], X, 2).
bits_to_number_([X | Xs], OutN, OutUnit) :-
	bits_to_number_(Xs, N, Unit),
	OutN is N + Unit * X,
	OutUnit is 2 * Unit.

fst([X | _], X).
fst_eq(Expect, [X | _]) :- Expect = X.

tail([_ | Xs], Xs).

filter_match(Mapping, Samples, Match) :-
	filter_match_(Mapping, Samples, [], Match).

filter_match_(_, [], Prefix, Prefix).
filter_match_(_, [X | []], Prefix, Match) :- append(Prefix, X, Match).
filter_match_(Mapping, Xs, Prefix, Match) :-
	maplist(fst, Xs, Samples),
	majority_sample(Mapping, Samples, Major),
	include(fst_eq(Major), Xs, FilteredXs),
	maplist(tail, FilteredXs, NextSamples),
	append(Prefix, [Major], NextPrefix),
	filter_match_(Mapping, NextSamples, NextPrefix, Match).

main(_) :-
	read_samples("./in/day_03.txt", Rows),
	transpose(Rows, Columns),
	maplist(majority_sample(keep_bit), Columns, GammaRateBits),
	maplist(flip_bit, GammaRateBits, EpsilonRateBits),
	bits_to_number(GammaRateBits, GammaRate),
	bits_to_number(EpsilonRateBits, EpsilonRate),
	PowerConsumption is GammaRate * EpsilonRate,
	filter_match(keep_bit, Rows, O2RatingBits),
	filter_match(flip_bit, Rows, CO2RatingBits),
	bits_to_number(O2RatingBits, O2Rating),
	bits_to_number(CO2RatingBits, CO2Rating),
	LifeSupportRating is O2Rating * CO2Rating,
	write("power consumption of the submarine"), nl,
	write(PowerConsumption), nl, nl,
	write("life support rating of the submarine"), nl,
	write(LifeSupportRating), nl.
