%% API
-module(test3).
-export([test/0]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. Apr 2015 3:26 PM
%%%-------------------------------------------------------------------
-author("Li").

test() ->
	factorial(-5).

factorial(0) ->
	1;
factorial(N) when N > 0 ->
	N * factorial(N - 1).
