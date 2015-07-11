%% @author Administrator
%% @doc @todo Add description to afile_server.


-module(afile_server).

%% ====================================================================
%% API function
%% ====================================================================
-export([start/1, loop/1, start1/1, loop1/1]).


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
			Client ! {self(), file:read_file(filename:join(Dir, File))};
		{Client, {put_file, FromFile, ToFileName}} ->
			FullToFile = filename:join(Dir, ToFileName),
			{Status, FileBytes} = file:read_file(FromFile),
			case Status of
				ok ->
					Client ! {self(), file:write_file(FullToFile, FileBytes)};
				error ->
					Client ! {self(), Status}
			end
	end,
	loop(Dir).

start1(Dir) ->
	spawn(afile_server2, loop1, [Dir]).

loop1(Dir) ->
	receive
		{Client, list_dir} ->
			Client ! {self(), file:list_dir(Dir)};

		{Client, {get_file, File}} ->
			Full = filename:join(Dir, File),
			Client ! {self(), file:read_file(Full)};

		{Client, {put_file, FromFilePath}} ->
			ToFileName = filename:basename(FromFilePath),
			ToFilePath = filename:join(Dir, ToFileName),
			Result = file:copy(FromFilePath, ToFilePath),
			Client ! {self(), Result}
	end,
	loop1(Dir).