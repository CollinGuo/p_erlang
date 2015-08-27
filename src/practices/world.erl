%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 10. Apr 2015 10:24 AM
%%%-------------------------------------------------------------------
-module(world).
-author("Shuieryin").

%% API
-export([start/0]).

start() ->
    Joe = spawn(person, init, ["Joe"]),
    Susannah = spawn(person, init, ["Susannah"]),
    Dave = spawn(person, init, ["Dave"]),
    Andy = spawn(person, init, ["Andy"]),
    Rover = spawn(person, init, ["Rover"]),
    Rabbit1 = spawn(person, init, ["Flospy"]),

    {pidsOfNames, Joe, Susannah, Dave, Andy, Rover, Rabbit1}.

