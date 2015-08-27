%% API
-module(test2).
-export([f1/0]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 29. Apr 2015 10:04 AM
%%%-------------------------------------------------------------------
-author("Shuieryin").

f1() ->
    tuple_size(list_to_tuple([a, b, c])).