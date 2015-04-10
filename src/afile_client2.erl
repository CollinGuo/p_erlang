%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Apr 2015 11:52 AM
%%%-------------------------------------------------------------------
-module(afile_client2).
-author("Li").

%% API
-export([ls/1, get_file/2, put_file/2]).

ls(Server) ->
    Server ! {self(), list_dir},
    receive
        {Server, FileList} ->
            FileList
    end.

get_file(Server, File) ->
    Server ! {self(), {get_file, File}},
    receive
        {Server, Content} ->
            Content
    end.

put_file(Server, FromFilePath) ->
    Server ! {self(), {put_file, FromFilePath}},
    receive
        {Server, Result} ->
            Result
    end.
