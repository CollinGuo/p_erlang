%% API
-module(test1).
-export([f1/0]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Apr 2015 7:22 PM test push
%%%-------------------------------------------------------------------
-author("Li").

f1() ->
	X = erlang:time(),
	seconds(X).

seconds({_Year, _Month, _Day, Hour, Min, Sec}) ->
	(Hour * 60 + Min) * 60 + Sec.
