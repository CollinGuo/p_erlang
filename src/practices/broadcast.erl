%% API
-module(broadcast).
-export([send/1, listen/0]).
-import(inet, [ifget/2]).
-import(gen_udp, [send/4, open/2, open/1, close/1]).
-import(io, [format/2]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 14. Jul 2015 9:20 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

send(IoList) ->
	%% 	The "eth0" is wrong hence not able to test this module
	case ifget("eth0", [broadaddr]) of
		{ok, [{broadaddr, Ip}]} ->
			{ok, S} = open(5010, [{broadcast, true}]),
			send(S, Ip, 6000, IoList),
			close(S);
		Any ->
			format("Bad interface name, or broadcasting not supported: ~p~n", [Any])
	end.

listen() ->
	{ok, _} = open(6000),
	loop().

loop() ->
	receive
		Any ->
			format("received:~p~n", [Any]),
			loop()
	end.