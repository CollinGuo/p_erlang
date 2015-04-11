%% @author Administrator
%% @doc @todo Add description to afile_server.


-module(afile_server).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1, loop/1]).


%% ====================================================================
%% Internal functions
%% ====================================================================

start(Dir) ->
    spawn(afile_server, loop, [Dir]).

loop(Dir) ->
    receive
        {Client, list_dir} ->
            Client ! {self(), file:list_dir(Dir)};
        {Client, {get_file, File}} ->
            Client ! {self(), getFile(Dir, File)};
        {Client, {put_file, FromFile, ToFileName}} ->
            FullToFile = filename:join(Dir, ToFileName),
%%             FileTp = file:read_file(FromFile),
%%             FileStatus = element(1, FileTp),
%%             Result = element(2, file:read_file(FromFile)),
%%             if
%%                 ok == FileStatus ->
%%                     Client ! {self(), file:write_file(FullToFile, Result)};
%%                 error == FileStatus ->
%%                     Client ! {self(), Result}
%%             end

            Result = file:read_file(FromFile),
            case Result of
                ok ->
                    Client ! {self(), file:write_file(FullToFile, Result)};
                error ->
                    Client ! {self(), Result}
            end
    end,
    loop(Dir).

getFile(Dir, File) ->
    Full = filename:join(Dir, File),
    file:read_file(Full).