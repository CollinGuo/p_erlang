%% API
-module(lib_misc2).
-export([start/0, for/3, qasort/1, qdsort/1, qsort/2, pythag/1, perms/1, max/2, filter1/2, odds_and_evens1/1, odds_and_evens2/1, my_tuple_to_list/1, now_milli/0, my_date_string/0, my_time_func/0]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Apr 2015 5:56 PM
%%%-------------------------------------------------------------------
-author("Li").

start() ->
	L = [6, 2, 9, 27, 400, 78, 45, 61, 82, 14, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82],
	qsort(L, asc).
%% 	T = {a, b, c, d, e},
%% 	erlang:display(my_tuple_to_list(T)).

for(Max, Max, F) ->
	[F(Max)];
for(I, Max, F) ->
	[F(I) | for(I + 1, Max, F)].

qsort(TargetList, Mode) ->
	case Mode of
		asc ->
			qasort(TargetList);
		desc ->
			qdsort(TargetList)
	end.

%% ascending sort
qasort([]) ->
	[];
qasort([Pivot | T]) ->
	qasort([X || X <- T, X < Pivot])
	++ [Pivot] ++
		qasort([X || X <- T, X >= Pivot]).

%% descending sort
qdsort([]) ->
	[];
qdsort([Pivot | T]) ->
	qdsort([X || X <- T, X >= Pivot])
	++ [Pivot] ++
		qdsort([X || X <- T, X < Pivot]).

%% Steps for ascending qsort[3,5,2,4,1].
%% 1 - qsort([3 | [5,2,4,1]]) ->
%% 		qsort([2,1])
%% 		++ [3] ++
%% 		qsort([5,4]).
%% 2 - qsort([2|[1]]) ->
%% 		qsort([1])
%% 		++ [2] ++
%% 		qsort([]).
%% 3 - qsort([5|[4]]) ->
%% 		qsort([4])
%% 		++ [5] ++
%% 		qsort([]).
%% 4 - step2 + step1 + step3 => [1] ++ [2] ++ [] ++ [3] ++ [4] ++ [5] ++ [].
%%
%% 5 - [1,2,3,4,5].

pythag(N) ->
	[{A, B, C} ||
		A <- lists:seq(1, N),
		B <- lists:seq(1, N),
		C <- lists:seq(1, N),
		A + B + C =< N,
		A * A + B * B =:= C * C
	].

perms([]) ->
	[[]];
perms(List) ->
	[[Head | Tail] || Head <- List, Tail <- perms(List--[Head])].

%% Steps for perms("123")
%% 1 - [1, perms("23")] -> [2, perms("3")] -> [3, perms([])] => 123
%% 						[3, perms("2")] -> [2, perms([])] => 132
%% 2 - [2, perms("13")] -> [1, perms("3")] -> [3, perms([])] => 213
%% 						[3, perms("1")] -> [1, perms([])] => 231
%% 3 - [3, perms("12")] -> [1, perms("2")] -> [2, perms([])] => 312
%% 						[2, perms("1")] -> [1, perms([])] => 321
%% final output ["123", "132", "213", "231", "312", "321"].

max(X, Y) when is_integer(X), is_integer(Y), X > Y ->
	X;
max(X, Y) when is_integer(X), is_integer(Y) ->
	Y.

filter1(Func, [Head | Tail]) ->
	case Func(Head) of
		true ->
			[Head | filter1(Func, Tail)];
		false ->
			filter1(Func, Tail)
	end;
filter1(_, []) ->
	[].

odds_and_evens1(List) ->
	Odds = [Odd || Odd <- List, Odd rem 2 =:= 1],
	Evens = [Even || Even <- List, Even rem 2 =:= 0],
	{Odds, Evens}.

odds_and_evens2(List) ->
	odds_and_evens_acc(List, [], []).

odds_and_evens_acc([Head | Tail], Odds, Evens) ->
	case (Head rem 2) of
		1 ->
			odds_and_evens_acc(Tail, [Head | Odds], Evens);
		0 ->
			odds_and_evens_acc(Tail, Odds, [Head | Evens])
	end;
odds_and_evens_acc([], Odds, Evens) ->
	{Odds, Evens}.

my_tuple_to_list(Tuple) ->
	my_tuple_to_list_acc(size(Tuple), Tuple, []).

my_tuple_to_list_acc(0, _, List) ->
	List;
my_tuple_to_list_acc(Count, Tuple, List) when is_integer(Count), is_tuple(Tuple), is_list(List) ->
	TailElement = element(Count, Tuple),
	my_tuple_to_list_acc(Count - 1, Tuple, [TailElement | List]).

now_milli() ->
	{MegaSecs, Secs, MicroSecs} = now(),
	(MegaSecs * 1000000 + Secs) * 1000 + MicroSecs div 1000.

my_date_string() ->
	{Year, Month, Day} = date(),
	{Hour, Minute, Second} = time(),
	erlang:display(Hour ++ ":" ++ Minute ++ ":" ++ Second ++ "," ++ Year ++ "-" ++ Month ++ "-" ++ Day).

my_time_func() ->
	StartTime = now(),
	start(),
	erlang:display(timer:now_diff(now(), StartTime)).

%% count_characters(Str) ->
%% 	count_characters_acc(Str, #{}, 0).
%%
%% count_characters_acc([], ResultMap, _) ->
%% 	ResultMap;
%% count_characters_acc([Head | Tail], CalcMap, Value) ->
%% 	count_characters_acc(Tail, CalcMap#{Head=>Value + 1});
%% count_characters_acc([Head | Tail], CalcMap, 0) ->
%% 	count_characters_acc(Tail, CalcMap#{Head=>1}).
