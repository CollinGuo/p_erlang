%% API
-module(dist_demo).
-export([rpc/4, start/1]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Jun 2015 10:09 PM
%%%-------------------------------------------------------------------
-author("Li").

%% Pid = dist_demo:start('col1@localhost').
%% dist_demo:rpc(Pid, erlang, node, []).ss

start(Node) ->
	spawn(
		Node,
		fun() ->
			loop()
		end
	).

rpc(ServerPid, M, F, A) ->
	ClientPid = self(),
	ServerPid ! {rpc, ClientPid, M, F, A},
	receive
		{ServerPid, Response} ->
			Response
	end.

loop() ->
	ServerPid = self(),
	receive
		{rpc, ClientPid, M, F, A} ->
			ClientPid ! {ServerPid, (catch apply(M, F, A))},
			loop()
	end.