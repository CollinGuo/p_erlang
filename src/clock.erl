%% API
-module(clock).
-export([start/2, stop/0]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Jun 2015 3:02 PM
%%%-------------------------------------------------------------------
-author("Li").

start(Time, Fun) ->
	register(
		clock,
		spawn(
			fun() ->
				tick(Time, Fun)
			end
		)
	).

stop() ->
	clock ! stop.

tick(Time, Fun) ->
	receive
		stop ->
			void
	after
		Time ->
			Fun(),
			tick(Time, Fun)
	end.
