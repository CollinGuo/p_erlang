%% @author Administrator
%% @doc @todo Add description to geometry.


-module(geometry).

%% ====================================================================
%% API functions
%% ====================================================================
-export([area/1]).


%% ====================================================================
%% Internal functions
%% ====================================================================

area({rectangle, Width, Height}) ->
    Width * Height;
area({square, Side}) ->
    Side * Side;
area({circle, Radius}) ->
    3.14159 * Radius * Radius.
