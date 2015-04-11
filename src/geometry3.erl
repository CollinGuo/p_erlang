%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Apr 2015 9:26 PM
%%%-------------------------------------------------------------------
-module(geometry3).
-author("Li").

%% API
-import(geometry2, [area/1]).
-export([test/0]).

test() ->
    12 = area({rectangle, 3, 4}),
    144 = area({square, 12}),
    452.38933440000005 = area({circle, 12}),
    tests_worked.
