%% API
-module(user_default).
-export([hello/0, away/1]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2015 8:31 PM
%%%-------------------------------------------------------------------
-author("Li").

hello() ->
	"Hello Joe how are you?".

away(Time) ->
	io:format("Joe is away and will be back in ~w minutes~n", [Time]).