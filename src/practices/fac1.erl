%% API
-module(fac1).
-export([main/1]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 26. May 2015 9:32 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

main([A]) ->
	I = list_to_integer(atom_to_list(A)),
	F = fac(I),
	io:format("factorial ~w = ~w, ~w~n", [I, F, A]),
	init:stop().

fac(0) ->
	1;
fac(N) ->
	N * fac(N - 1).