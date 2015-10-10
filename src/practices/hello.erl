%% @author Administrator
%% @doc @todo Add description to hello.


-module(hello).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0, test/1]).


%% ====================================================================
%% Internal functions
%% ====================================================================

start() ->
    io:format("Hello world erlang~n").

test(Var) ->
    Var.