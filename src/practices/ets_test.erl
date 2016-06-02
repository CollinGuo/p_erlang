%%%-------------------------------------------------------------------
%%% @author shuieryin
%%% @copyright (C) 2016, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 02. Jun 2016 7:48 AM
%%%-------------------------------------------------------------------
-module(ets_test).
-author("shuieryin").

%% API
-export([start/0]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Comment starts here
%%
%% @end
%%--------------------------------------------------------------------
start() ->
    lists:foreach(fun test_ets/1, [set, ordered_set, bag, duplicate_bag]).

test_ets(Mode) ->
    TableId = ets:new(test, [Mode]),
    ets:insert(TableId, {a, 1}),
    ets:insert(TableId, {b, 2}),
    ets:insert(TableId, {a, 1}),
    ets:insert(TableId, {a, 3}),
    List = ets:tab2list(TableId),
    io:format("~-15w  => ~p~n", [Mode, List]),
    ets:delete(TableId).

%%%===================================================================
%%% Internal functions (N/A)
%%%===================================================================