%% API
-module(user_default).
-export([hello/0, away/1]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2015 8:31 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

hello() ->
	"Hello Joe how are you?".

away(Time) ->
	io:format("Joe is away and will be back in ~w minutes~n", [Time]).