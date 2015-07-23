%% @author Administrator
%% @doc @todo Add description to afile_client.


-module(afile_client).

%% ====================================================================
%% API functions
%% ====================================================================
-export([ls/1, get_file/2, put_file/2, ls1/1, get_file1/2, put_file1/2]).


%% ====================================================================
%% Internal functions
%% ====================================================================

ls(Server) ->
	Server ! {self(), list_dir},
	receive
		{Server, FileList} -> FileList
	end.

get_file(Server, File) ->
	Server ! {self(), {get_file, File}},
	receive
		{Server, Content} -> Content
	end.

put_file(Server, FromFile) ->
	ToFileName = filename:basename(FromFile),
	Server ! {self(), {put_file, FromFile, ToFileName}},
	receive
		{Server, Content} -> Content
	end.

ls1(Server) ->
	Server ! {self(), list_dir},
	receive
		{Server, FileList} ->
			FileList
	end.

get_file1(Server, File) ->
	Server ! {self(), {get_file, File}},
	receive
		{Server, Content} ->
			Content
	end.

put_file1(Server, FromFilePath) ->
	Server ! {self(), {put_file, FromFilePath}},
	receive
		{Server, Result} ->
			Result
	end.
