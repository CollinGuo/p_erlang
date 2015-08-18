-module(webtest).
-export([start/0]).

start() ->
    io:format("a web test....~n"),
    Port = 13579,
    io:format("Load the page http://localhost:~p/ in your browser~n", [Port]),
    ezwebframe:start_link(fun dispatch/1, Port).

%% dispatch maps names in the HTML onto fixed paths 

dispatch(F) ->
    F1 = dispatch1(F),
    io:format("ezwebframe_demos::dispatch ~s => ~s~n", [F, F1]),
    F1.

dispatch1("/ezwebframe/" ++ F) ->
    Dir = dir(2, code:which(ezwebframe)) ++ "/priv/",
    Dir ++ F;
dispatch1("/" ++ F) ->
    Dir = dir(2, code:which(?MODULE)) ++ "/",
    Dir ++ F.

dir(0, F) -> F;
dir(K, F) -> dir(K - 1, filename:dirname(F)).