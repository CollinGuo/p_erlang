%% API
-module(fac).
-export([fac/1]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 26. May 2015 9:29 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

fac(0) ->
	1;
fac(N) ->
	N * fac(N - 1).
