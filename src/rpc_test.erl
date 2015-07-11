%% API
-module(rpc_test).
-export([init/1, direct_return/0, deplayed_return/0, server_call_test_server/0, parallel_eval_test/1, global_register_name_test/0, global_trans_lock_test/0]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Jun 2015 9:11 PM
%%%-------------------------------------------------------------------
-author("Li").

-behaviour(ch13).

%% Key = rpc:async_call('col@192.168.1.103', rpc_test, direct_return, []).
%% Key = rpc:async_call('col@192.168.1.103', rpc_test, deplayed_return, []).
%% io:format("~p~n", [rpc:yield(Key)]).
%% io:format("~p~n", [rpc:nb_yield(Key)]).
%% io:format("~p~n", [rpc:nb_yield(Key, 3000)]).

init(Smth) ->
	Smth.

%% rpc:call('col@192.168.1.103', rpc_test, deplayed_return, []).

direct_return() ->
	hi_there.

deplayed_return() ->
	io:format("~p~n", ["I'm being called."]),
	timer:sleep(3000),
	hi_there.

%% server side: register(scts, spawn(rpc_test, server_call_test_server, [])).
%% client side: Msg = rpc:server_call('col1@localhost', scts, hello, {hello, 'col1@localhost', "can u hear me?"}).

%% server side: register(mscts, spawn(rpc_test, server_call_test_server, [])).
%% client side: {Replies, BadNodes} = rpc:multi_server_call(['col1@localhost', 'col2@localhost'], mscts, {hello, mscts, 'col1@localhost', "can u hear me?"}).

server_call_test_server() ->
	receive
		{Client, {hello, Node, Msg}} ->
			io:format("~p~n", [Msg]),
			Client ! {hello, Node, "I got this single call message!"};
		{Client, {hello, Name, Node, Msg}} ->
			io:format("~p~n", [Msg]),
			Client ! {Name, Node, "I got this multi call message!"}
	end,
	server_call_test_server().

%% client side: net_adm:ping('col1@localhost').
%% client side: ResL = rpc:parallel_eval([{rpc_test, parallel_eval_test, [23]}]).
%% multi_parallel_eval refers to pmap(FuncSpec, ExtraArgs, List1) -> List2

parallel_eval_test(X) ->
	io:format("The original value is ~p.~n", [X]),
	X * 234.

%% rpc:pinfo(spawn(fun() -> true end)).
%% process_info(spawn(fun() -> true end)).

%% rpc:pinfo(spawn(fun() -> true end), initial_call).
%% process_info(spawn(fun() -> true end), initial_call).


%% net_adm:ping('col1@localhost').
%% global:register_name(grnt, spawn(rpc_test, global_register_name_test, [])).
%% global:register_name(grnt, spawn(rpc_test, global_register_name_test, []), {global, notify_all_name}).
%% global:send(grnt, {hello, "hello there."}).

global_register_name_test() ->
	receive
		{hello, Msg} ->
			io:format("~p~n", [Msg]);
		{global_name_conflict, Name} ->
			io:format("global_name_conflict: ~p~n", [Name])
	end,
	global_register_name_test().

%% net_adm:ping('col1@localhost').
%% global:trans

global_trans_lock_test() ->
	timer:sleep(5000),
	io:format("I'm up!~n").

%% shell0: net_adm:ping('col1@localhost').
%% shell0: global:register_name(shell0, self()).
%% shell1: global:register_name(shell1, self()).
%% shell0: link(global:whereis_name(shell1)).
%% shell0 & shell1: global:registered_names().
%% shell0 & shell1: {links, LinkedProcesses} = process_info(self(), links).