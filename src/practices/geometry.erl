%% @author Administrator
%% @doc @todo Add description to geometry.


-module(geometry).

%% ====================================================================
%% API functions
%% ====================================================================
-export([area/1, test/0]).


%% ====================================================================
%% Internal functions
%% ====================================================================

test() ->
	12 = area({rectangle, 3, 4}),
	144 = area({square, 12}),
	452.38933440000005 = area({circle, 12}),
	tests_worked.

area({rectangle, Width, Height}) ->
	Width * Height;
area({square, Side}) ->
	Side * Side;
area({circle, Radius}) ->
	3.141592654 * Radius * Radius;
area({perpendicular_triangle, RightAngleSide1, RightAngleSide2}) ->
	RightAngleSide1 * RightAngleSide2 / 2.

