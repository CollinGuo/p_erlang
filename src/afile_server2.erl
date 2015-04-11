%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Apr 2015 11:13 AM
%%%-------------------------------------------------------------------
-module(afile_server2).
-author("Li").

%% API
-export([start/1, loop/1]).

start(Dir) ->
    spawn(afile_server2, loop, [Dir]).

loop(Dir) ->
    receive
        {Client, list_dir} ->
            Client ! {self(), file:list_dir(Dir)};

        {Client, {get_file, File}} ->
            Full = filename:join(Dir, File),
            Client ! {self(), file:read_file(Full)};

        {Client, {put_file, FromFilePath}} ->
            Filename = filename:basename(FromFilePath),
            Client ! {self(), file:copy(FromFilePath, filename:join(Dir, Filename))}
    end,
    loop(Dir).