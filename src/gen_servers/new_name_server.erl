-module(new_name_server).
%% API
-export([all_names/0, add/2, find/1, delete/1, init/0, handle/2]).
-import(server3, [rpc/2]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Aug 2015 7:18 AM
%%%-------------------------------------------------------------------
-author("Li").

all_names() ->
    rpc(name_server, allNames).

add(Name, Place) ->
    rpc(name_server, {add, Name, Place}).

find(Name) ->
    rpc(name_server, {find, Name}).

delete(Name) ->
    rpc(name_server, {delete, Name}).

init() ->
    dict:new().

handle({add, Name, Place}, Dict) ->
    {ok, dict:store(Name, Place, Dict)};
handle(allNames, Dict) ->
    {dict:fetch_keys(Dict), Dict};
handle({delete, Name}, Dict) ->
    {ok, dict:erase(Name, Dict)};
handle({find, Name}, Dict) ->
    {dict:find(Name, Dict), Dict}.