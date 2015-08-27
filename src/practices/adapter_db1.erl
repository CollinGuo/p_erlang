-module(adapter_db1).
%% API
-export([new/1,
    store/3,
    lookup/2]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 12. Aug 2015 9:40 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

%%%===================================================================
%%% API
%%%===================================================================

new(dict) ->
    {?MODULE, dict, dict:new()};
new(lists) ->
    {?MODULE, list, []}.

store(Key, Val, {_, dict, D}) ->
    D1 = dict:store(Key, Val, D),
    {?MODULE, dict, D1};
store(Key, Val, {_, list, L}) ->
    L1 = lists:keystore(Key, 1, L, {Key, Val}),
    {?MODULE, list, L1}.

lookup(Key, {_, dict, D}) ->
    dict:find(Key, D);
lookup(Key, {_, list, L}) ->
    case lists:keysearch(Key, 1, L) of
        {value, {Key, Val}} ->
            {ok, Val};
        false ->
            error
    end.

%%%===================================================================
%%% Internal functions
%%%===================================================================
