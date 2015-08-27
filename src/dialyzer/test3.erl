%% API
-module(test3).
-export([test/0]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 30. Apr 2015 3:26 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

test() ->
	factorial(-5).

factorial(0) ->
	1;
factorial(N) when N > 0 ->
	N * factorial(N - 1).
