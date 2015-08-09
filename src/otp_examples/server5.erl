-module(server5).
%% API
-export([start/0, rpc/2]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Aug 2015 10:18 AM
%%%-------------------------------------------------------------------
-author("Li").

start() ->
    spawn(
        fun() ->
            wait()
        end
    ).

wait() ->
    receive
        {become, F} -> F()
    end.

rpc(Pid, Q) ->
    Pid ! {self(), Q},
    receive
        {Pid, Reply} ->
            Reply
    end.