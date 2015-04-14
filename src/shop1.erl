%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Apr 2015 2:36 PM
%%%-------------------------------------------------------------------
-module(shop1).
-author("Li").

%% API
-export([cost/1]).

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
