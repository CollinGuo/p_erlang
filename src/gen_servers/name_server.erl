-module(name_server).
%% API
-export([init/0, add/2, find/1, handle/2]).
-import(server1, [rpc/2]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Jul 2015 10:03 PM
%%%-------------------------------------------------------------------
-author("Li").

add(Name, Place) ->
    rpc(name_server, {add, Name, Place}).

find(Name) ->
    rpc(name_server, {find, Name}).

init() ->
    dict:new().

handle({add, Name, Place}, Dict) ->
    {ok, dict:store(Name, Place, Dict)};
handle({find, Name}, Dict) ->
    {dict:find(Name, Dict), Dict}.