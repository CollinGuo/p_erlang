%% API
-module(test1).
-export([f1/0]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 28. Apr 2015 7:22 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

f1() ->
	X = erlang:time(),
	seconds(X).

seconds({_Year, _Month, _Day, Hour, Min, Sec}) ->
	(Hour * 60 + Min) * 60 + Sec.
