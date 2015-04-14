%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Apr 2015 2:30 PM
%%%-------------------------------------------------------------------
-module(file_test).
-author("Li").

%% API
-import(afile_server2, [start/1]).
-import(afile_client2, [ls/1, get_file/2, put_file/2]).
-export([start/0]).

start() ->
	FileServer = afile_server2:start("."),
	afile_client2:put_file(FileServer, "C:/Users/Li/Desktop/abc.txt").

