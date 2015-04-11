%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Apr 2015 7:57 PM
%%%-------------------------------------------------------------------
-module(geometry2).
-author("Li").

%% API
-export([area/1]).

area({rectangle, Width, Height}) ->
    Width * Height;
area({square, Side}) ->
    Side * Side;
area({circle, Radius}) ->
    3.1415926 * Radius * Radius.

