%% API
-module(socket_examples).
-export([nano_get_url/0, start_nano_server/0, nano_client_eval/1]).
-import(gen_tcp, [connect/3, send/2, listen/2, accept/1, close/1]).
-import(lists, [reverse/1]).
-import(io, [format/1, format/2]).
-import(lib_misc, [string2value/1]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 09. Jul 2015 9:28 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

nano_get_url() ->
	nano_get_url("www.baidu.com").

nano_get_url(Host) ->
	{ok, Socket} = connect(Host, 80, [binary, {packet, 0}]),
%% 	io:format("Socket: ~p~n", [Socket]),
	ok = send(Socket, "GET / HTTP/1.0\r\n\r\n"),
	receive_data(Socket, []).

receive_data(Socket, SoFar) ->
	receive
		{tcp, Socket, Bin} ->
%% 			io:format("Bin: ~p~n", [Bin]),
			receive_data(Socket, [Bin | SoFar]);
		{tcp_closed, Socket} ->
			list_to_binary(reverse(SoFar))
	end.

start_nano_server() ->
	{ok, Listen} = listen(2345, [binary, {packet, 4}, {reuseaddr, true}, {active, true}]),
	{ok, Socket} = accept(Listen),
	close(Listen),
	loop(Socket).

loop(Socket) ->
	receive
		{tcp, Socket, Bin} ->
			io:format("loop(Socket).{tcp, Socket, Bin}:~n Socket [~p]~n Bin [~p]~n", [Socket, Bin]),
			format("Server received binary = ~p~n", [Bin]),
			Str = binary_to_term(Bin),
			format("Server (unpacked) ~p~n", [Str]),
			Reply = string2value(Str),
			format("Server replying = ~p~n", [Reply]),
			send(Socket, term_to_binary(Reply)),
			loop(Socket);
		{tcp_closed, Socket} ->
			io:format("loop(Socket).{tcp_closed, Socket}:~n Socket [~p]~n", [Socket]),
			format("Server socket closed~n");
		Any ->
			io:format("loop(Socket).Any:~n Any: [~p]~n", [Any])
	end.

nano_client_eval(Str) ->
	{ok, Socket} = connect("localhost", 2345, [binary, {packet, 4}]),
	ok = send(Socket, term_to_binary(Str)),
	receive
		{tcp, Socket, Bin} ->
			format("Client received binary = ~p~n", [Bin]),
			Val = binary_to_term(Bin),
			format("Client result = ~p~n", [Val]),
			close(Socket)
	end.