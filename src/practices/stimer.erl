%% API
-module(stimer).
-export([start/2, cancel/1]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 31. May 2015 5:39 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

start(Time, Fun) ->
	spawn(
		fun() ->
			timer(Time, Fun)
		end
	).

cancel(Pid) ->
	Pid ! cancel.

timer(Time, Fun) ->
	receive
		cancel ->
			void
	after
		Time ->
			Fun()
	end.