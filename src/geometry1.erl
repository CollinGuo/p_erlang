%% @author Administrator
%% @doc @cat todo Add description to geometry.


-module(geometry1).

%% ====================================================================
%% API functions
%% ====================================================================
-export([test/0, area/1]).


%% ====================================================================
%% Internal functions
%% ====================================================================

test() ->
    12 = area({rectangle, 3, 4}),
    144 = area({square, 12}),
    tests_worked.

area({rectangle, Width, Height}) ->
    Width * Height;
area({square, Side}) ->
    Side * Side.