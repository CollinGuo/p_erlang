%% API
-module(ch12_ex1).
-export([test/0]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 07. Jun 2015 4:53 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

test() ->
	Fun1 = fun() ->
		start(
			t1,
			fun() ->
				io:format("value: ~p~n", [7429837429834 * 2378473284])
			end,
			first
		)
	end,
	Fun2 = fun() ->
		start(
			t2,
			fun() ->
				io:format("value: ~p~n", [abc])
			end,
			second
		)
	end,
	spawn(Fun1),
	spawn(Fun2).

start(AnAtom, Fun, Name) ->
	try
		register(AnAtom, spawn(Fun))
	catch
		Any ->
			io:format("Error: ~w, Name: ~w~n", [Any, Name])
	end.