%% API
-module(attrs).
-export([]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 25. Apr 2015 3:19 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").
-vsn(1234).
-purpose("example of attributes").
-export([start/0, fac/1]).

start() ->
	%% beam_lib:chunks("attrs.beam", [attributes]).
	module_info().

fac(1) ->
	1;
fac(N) ->
	N * fac(N - 1).
