-module(server1).
%% API
-export([start/2, rpc/2]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 29. Jul 2015 9:47 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

start(Name, Mod) ->
    register(Name, spawn(
        fun() ->
            loop(Name, Mod, Mod:init())
        end
    )).

rpc(Name, Request) ->
    Name ! {self(), Request},
    receive
        {Name, Response} ->
            Response
    end.

loop(Name, Mod, State) ->
    receive
        {From, Request} ->
            {Response, State1} = Mod:handle(Request, State),
            From ! {Name, Response},
            loop(Name, Mod, State1)
    end.