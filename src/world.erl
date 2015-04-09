%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. ËÄÔÂ 2015 22:51
%%%-------------------------------------------------------------------
-module(world).
-author("Li").

%% API
-export([start/0]).

start() ->
    Joe = spawn(person, init, ["Joe"]),
    Susannah = spawn(person, init, ["Susannah"]),
    Dave = spawn(person, init, ["Dave"]),
    Andy = spawn(person, init, ["Andy"]),
    Rover = spawn(person, init, ["Rover"]),
    Rabbit1 = spawn(person, init, ["Flospy"]).