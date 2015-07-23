%% API
-module(ch13).
-export([main/0, simple_server1/0, simple_server2/0]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Jun 2015 5:00 PM
%%%-------------------------------------------------------------------
-author("Li").

-callback init(Args :: term()) ->
	{ok, State :: term()} | {ok, State :: term(), timeout() | hibernate} |
	{stop, Reason :: term()} | ignore.

%% {Ss1Pid, Ss2Pid} = ch13:main().
%% Ss1Pid ! is_alive.
%% Ss1Pid ! {link, Ss2Pid}.
%% Ss2Pid ! crash.
%% Ss1Pid ! is_alive.

main() ->
	Ss2Pid = spawn(?MODULE, simple_server2, []),
	register(simple_server2, Ss2Pid),

	Ss1Pid = spawn(?MODULE, simple_server1, []),
	register(simple_server1, Ss1Pid),

	io:format("Ss1Pid: ~p~nSs2Pid: ~p~n", [Ss1Pid, Ss2Pid]),

%% 	Ss1Pid ! {link, Ss2Pid},
	{Ss1Pid, Ss2Pid}.

simple_server1() ->
	receive
		is_alive ->
			io:format("yes~n");
		{link, Ss2Pid} ->
%% 			process_flag(trap_exit, true), % by uncommenting this line, the current process becomes system_process which will not die if the linked process dies.
			link(Ss2Pid),
			io:format("linked~n");
		{monitor, Ss2Pid} ->
			monitor(process, Ss2Pid),
			io:format("monitored~n");
		{'DOWN', _Ref, process, _Ss2Pid, Why} ->
			io:format("Ss2 down message: ~p~n", [Why]) % restart simple_server2 if needed and return the Pid back to the monitor process
	end,
	simple_server1().

simple_server2() ->
	receive
		Any ->
			%% the process crashes when "Any" is not string
			io:format("~p~n", [list_to_atom(Any)])
	end,
	simple_server2().
