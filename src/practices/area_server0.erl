%% API
-module(area_server0).
-export([loop/0]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 31. May 2015 10:50 AM
%%%-------------------------------------------------------------------
-author("Shuieryin").

loop() ->
	receive
		{rectangle, Width, Height} ->
			io:format("Area of rectangle is ~p~n", [Width * Height]);
		{square, Side} ->
			io:format("Area of square is ~p~n", [Side * Side])
	end,
	loop().