%% API
-module(chat1).
-export([start/1]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 25. Jul 2015 10:15 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

start(Browser) ->
	running(Browser, []).

running(Browser, L) ->
	receive
		{Browser, {struct, [{join, Who}]}} ->
			Browser ! [{cmd, append_div}, {id, scroll}, {txt, list_to_binary([Who, " join the group\n"])}],
			L1 = [Who, "<br>" | L],
			Browser ! [{cmd, fill_div}, {id, users}, {txt, list_to_binary(L1)}],
			running(Browser, L1);
		{Browser, {struct, [{entry, <<"tell">>}, {txt, Txt}]}} ->
			Browser ! [{cmd, append_div}, {id, scroll}, {txt, list_to_binary([" > ", Txt, "<br>"])}],
			running(Browser, L);
		X ->
			io:format("chat received:~p~n", [X])
	end,
	running(Browser, L).