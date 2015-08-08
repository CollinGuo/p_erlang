-module(my_fac_server).
%% API
-export([loop/0]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Aug 2015 10:24 AM
%%%-------------------------------------------------------------------
-author("Li").

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