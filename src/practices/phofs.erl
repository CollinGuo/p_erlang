-module(phofs).
%% API
-export([mapreduce/4]).
-import(lists, [foreach/2]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 16. Aug 2015 11:33 AM
%%%-------------------------------------------------------------------
-author("Shuieryin").

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% F1(Pid, X) -> sends {Keys,Val} messages to Pid
%% F2(Key, [Val], AccIn) -> AccOut
%%
%% @end
%%--------------------------------------------------------------------
mapreduce(F1, F2, Acc0, L) ->
    S = self(),
    Pid = spawn(
        fun() ->
            reduce(S, F1, F2, Acc0, L)
        end
    ),
    receive
        {Pid, Result} ->
            Result
    end.

%%%===================================================================
%%% Internal functions
%%%===================================================================

reduce(Parent, F1, F2, Acc0, L) ->
    process_flag(trap_exit, true),
    ReducePid = self(),
    %% Create the Map processes one for each element X in L
    foreach(
        fun(X) ->
            spawn_link(
                fun() ->
                    do_job(ReducePid, F1, X)
                end
            )
        end,
        L
    ),
    N = length(L),
    %% make a dictionary to store Keys
    Dict0 = dict:new(),
    %% Wait for N Map processes to terminate
    Dict1 = collect_replies(N, Dict0),
    Acc = dict:fold(F2, Acc0, Dict1),
    Parent ! {self(), Acc}.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% collect_replies(N, Dict) collect and merge {Key, Value} messages from N processese
%%      When N processes have teminated return a dictionary of {Key, [Value]} tuples
%%
%% @end
%%--------------------------------------------------------------------
collect_replies(0, Dict) ->
    Dict;
collect_replies(N, Dict) ->
    receive
        {Key, Val} ->
            case dict:is_key(Key, Dict) of
                true ->
                    Dict1 = dict:append(Key, Val, Dict),
                    collect_replies(N, Dict1);
                false ->
                    Dict1 = dict:store(Key, [Val], Dict),
                    collect_replies(N, Dict1)
            end;
        {'EXIT', _, _Why} ->
            collect_replies(N - 1, Dict)
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Call F(Pid, X)
%%      F must send {Key, Value} messages to Pid and then terminate
%% @end
%%--------------------------------------------------------------------
do_job(ReducePid, F, X) ->
    F(ReducePid, X).