-module(p_erlang_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
%%     Dispatch = cowboy_router:compile([{'_', ["./ebin/", hello_handler, []]}]),
%%     {ok, _} = cowboy:start_http(my_http_listener, 100, [{port, 8080}], [{env, [{dispatch, Dispatch}]}]),
    webtest:start(),
    p_erlang_sup:start_link().

stop(_State) ->
    ok.
