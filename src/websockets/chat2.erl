%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Jul 2015 4:43 PM
%%%-------------------------------------------------------------------
-module(chat2).
-author("Li").

%% API
-export([start/1]).

start(Browser) ->
    idle(Browser).

idle(Browser) ->
    receive
        {Browser, {struct, [{join, Who}]}} ->
            irc ! {join, self(), Who},
            idle(Browser);
        {irc, welcome, Who} ->
            Browser ! [{cmd, hide_div}, {id, idle}],
            Browser ! [{cmd, show_div}, {id, running}],
            running(Browser, Who);
        X ->
            io:format("chat idle received:~p~n", [X]),
            idle(Browser)
    end.

running(Browser, Who) ->
    receive
        {Browser, {struct, [{entry, <<"tell">>}, {txt, Txt}]}} ->
            irc ! {broadcast, Who, Txt},
            running(Browser, Who);
        {Browser, {struct, [{clicked, <<"Leave">>}]}} ->
            irc ! {leave, Who},
            Browser ! [{cmd, hide_div}, {id, running}],
            Browser ! [{cmd, show_div}, {id, idle}],
            idle(Browser);
        {irc, scroll, Bin} ->
            Browser ! [{cmd, append_div}, {id, scroll}, {txt, Bin}],
            running(Browser, Who);
        {irc, groups, Bin} ->
            Browser ! [{cmd, fill_div}, {id, users}, {txt, Bin}],
            running(Browser, Who);
        X ->
            io:format("chat running received:~p~n", [X]),
            running(Browser, Who)
    end.