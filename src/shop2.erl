%% @author Administrator
%% @doc @todo Add description to shop2.


-module(shop2).

%% ====================================================================
%% API functions
%% ====================================================================
-export([total/1]).
-import(lists, [map/2, sum/1]).


%% ====================================================================
%% Internal functions
%% ====================================================================
%% Buy = [{oranges, 4}, {newspaper, 1}, {apples, 10}, {pears, 6}, {milk, 3}].
%% L1 = lists:map(fun({What, N}) -> shop:cost(What) * N end, Buy).
%% shop2:total(Buy).

total(L) ->
    sum(
        map(
            fun({What, N}) ->
                shop:cost(What) * N end,
            L
        )
    ).
