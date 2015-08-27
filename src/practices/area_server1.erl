%% API
-module(area_server1).
-export([start/0, loop/0, area/2]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 31. May 2015 11:42 AM
%%%-------------------------------------------------------------------
-author("Shuieryin").

start() ->
	spawn(area_server1, loop, []).

area(Pid, What) ->
	rpc(Pid, What).

rpc(Pid, Request) ->
	Pid ! {self(), Request},
	receive
		{Pid, Response} ->
			Response
	end.

loop() ->
	receive
		{From, {rectangle, Width, Height}} ->
			From ! {self(), Width * Height};
		{From, {square, Side}} ->
			From ! {self(), Side * Side};
		{From, {circle, R}} ->
			From ! {self(), 3.141592654 * R * R};
		{From, Other} ->
			From ! {self(), {error, Other}}
	end,
	loop().