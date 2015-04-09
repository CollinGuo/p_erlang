%% @author Administrator
%% @doc @todo Add description to shop.


-module(shop).

%% ====================================================================
%% API functions
%% ====================================================================
-export([total/1, cost/1]).


%% ====================================================================
%% Internal functions
%% ====================================================================
%% shop:total([{pears,6},{milk,3}]).


total([{What, N} | T]) ->
    shop:cost(What) * N + total(T);
total([]) ->
    0.

cost(oranges) ->
    5;
cost(newspaper) ->
    8;
cost(apples) ->
    2;
cost(pears) ->
    9;
cost(milk) ->
    7.
