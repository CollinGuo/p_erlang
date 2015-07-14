%% API
-module(udp_test).
-export([start_server/0, client/1, fac/1]).
-import(gen_udp, [open/2, send/4, close/1]).
-import(io, [format/2]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jul 2015 8:31 PM
%%%-------------------------------------------------------------------
-author("Li").

start_server() ->
	spawn(
		fun() ->
			server(4000)
		end
	).

%% The server
server(Port) ->
	{ok, Socket} = open(Port, [binary]),
	format("server opened socket:~p~n", [Socket]),
	loop(Socket).

loop(Socket) ->
	receive
		{udp, Socket, Host, Port, Bin} = Msg ->
			format("server received:~p~n", [Msg]),
			N = binary_to_term(Bin),
			Fac = fac(N),
			send(Socket, Host, Port, term_to_binary(Fac)),
			loop(Socket)
	end.

fac(0) ->
	1;
fac(N) ->
	N * fac(N - 1).

%% The client
client(N) ->
	{ok, Socket} = open(0, [binary]),
	format("client opened socket=~p~n", [Socket]),
	ok = send(Socket, "localhost", 4000, term_to_binary(N)),
	Value = receive
		        {udp, Socket, _, _, Bin} = Msg ->
			        format("client received:~p~n", [Msg]),
			        binary_to_term(Bin)
	        after
		        2000 ->
			        0
	        end,
	close(Socket),
	Value.
