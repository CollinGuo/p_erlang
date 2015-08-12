-module(counter).
%% API
-export([bump/2,
    read/1]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Aug 2015 9:23 PM
%%%-------------------------------------------------------------------
-author("Li").

%%%===================================================================
%%% API
%% 1> c(counter).
%%     {ok,counter}
%%     Then create an instance of a tuple module.
%% 2> C = {counter,2}.
%%     {counter, 2}
%%     And we call get/0.
%% 3> C:read().
%%     2
%%     Because C is a tuple, this gets converted to the call counter:read({counter,2}),
%%     which returns 2.
%% 4> C1 = C:bump(3).
%%     {counter, 5}
%%     C:bump(3) gets converted to the call counter:bump(3, {counter, 2}) and so returns
%%     {counter, 5}.
%% 5> C1:read().
%%     5
%%%===================================================================

bump(N, {counter, K}) ->
    {counter, N + K}.

read({counter, N}) ->
    N.

%%%===================================================================
%%% Internal functions
%%%===================================================================
