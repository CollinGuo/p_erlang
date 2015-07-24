%% API
-module(clock1).
-export([start/1, current_time/0]).
-import(io_lib, [format/2]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Jul 2015 9:28 PM
%%%-------------------------------------------------------------------
-author("Li").

start(Browser) ->
	send_time(Browser),
	running(Browser).

running(Browser) ->
	receive
		{Browser, {struct, [{clicked, <<"stop">>}]}} ->
			idle(Browser)
	after
		1000 ->
			send_time(Browser),
			running(Browser)
	end.

send_time(Browser) ->
	Browser ! [{cmd, fill_div}, {id, clock}, {txt, current_time()}].

idle(Browser) ->
	receive
		{Browser, {struct, [{clicked, <<"start">>}]}} ->
			running(Browser)
	end.

current_time() ->
	{Hour, Min, Sec} = time(),
	list_to_binary(format("~2.2.0w:~2.2.0w:~2.2.0w", [Hour, Min, Sec])).