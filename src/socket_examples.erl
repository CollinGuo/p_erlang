%% API
-module(socket_examples).
-export([nano_get_url/0]).
-import(gen_tcp, [connect/3]).
-import(lists, [reverse/1]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Jul 2015 9:28 PM
%%%-------------------------------------------------------------------
-author("Li").

nano_get_url() ->
	nano_get_url("www.baidu.com").

nano_get_url(Host) ->
	{ok, Socket} = connect(Host, 80, [binary, {packet, 0}]),
%% 	io:format("Socket: ~p~n", [Socket]),
	ok = gen_tcp:send(Socket, "GET / HTTP/1.0\r\n\r\n"),
	receive_data(Socket, []).

receive_data(Socket, SoFar) ->
	receive
		{tcp, Socket, Bin} ->
%% 			io:format("Bin: ~p~n", [Bin]),
			receive_data(Socket, [Bin | SoFar]);
		{tcp_closed, Socket} ->
			list_to_binary(reverse(SoFar))
	end.