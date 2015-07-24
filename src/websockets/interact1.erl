%% API
-module(interact1).
-export([start/1]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Jul 2015 8:54 PM
%%%-------------------------------------------------------------------
-author("Li").

start(Browser) ->
	running(Browser).

running(Browser) ->
	receive
		{Browser, {struct, [{entry, <<"input">>}, {txt, Bin}]}} ->
			Time = clock1:current_time(),
			Browser ! [{cmd, append_div}, {id, scroll}, {txt, list_to_binary([Time, " > ", Bin, "<br>"])}];
		Error ->
			io:format("Error: ~p~n", [Error])
	end,
	running(Browser).