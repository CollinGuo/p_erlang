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
-import(afile_server, [start1/1]).
-import(afile_client, [ls1/1, get_file1/2, put_file1/2]).
-export([start/0]).

start() ->
	FileServer = afile_server:start1("."),
	afile_client:put_file1(FileServer, "C:/Users/Li/Desktop/abc.txt").

