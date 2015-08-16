-module(hello_handler).
-behaviour(cowboy_handler).

-export([init/2, terminate/3]).


init(Req, Opts) ->
    Req2 = cowboy_req:reply(200,
        [{<<"content-type">>, <<"text/plain">>}],
        <<"Hello Erlang!">>,
        Req),
    {ok, Req2, Opts}.

terminate(_Reason, _Req, _State) ->
    ok.