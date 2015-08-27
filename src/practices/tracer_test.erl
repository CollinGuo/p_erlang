-module(tracer_test).
%% API
-export([test1/0, fib/1]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 28. Jul 2015 10:08 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

-include_lib("stdlib/include/ms_transform.hrl").

%% noinspection ErlangUnresolvedFunction
test1() ->
    dbg:tracer(),
    dbg:tpl(?MODULE, fib, '_', dbg:fun2ms(
        fun(_) ->
            return_trace()
        end
    )),
    dbg:p(all, [c]),
    fib(4).

fib(0) ->
    1;
fib(1) ->
    1;
fib(N) ->
    fib(N - 1) + fib(N - 2).