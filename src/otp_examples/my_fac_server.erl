-module(my_fac_server).
%% API
-export([loop/0]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 08. Aug 2015 10:24 AM
%%%-------------------------------------------------------------------
-author("Shuieryin").

loop() ->
    receive
        {From, {fac, N}} ->
            From ! {self(), fac(N)},
            loop();
        {become, SomeThing} ->
            SomeThing()
    end.

fac(0) ->
    1;
fac(N) ->
    N * fac(N - 1).