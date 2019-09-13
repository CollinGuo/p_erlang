-module(phofs).
%% API
-export([
    mapreduce/4,
    test/0
]).
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

test() ->
    F1 =
        fun(ReducePid, X) ->
            ReducePid ! {X, X + 2}
        end,

    F2 =
        fun(Key, [Val | _Rest], AccFinalMap) ->
            AccFinalMap#{
                Key => Val
            }
        end,

    Result = mapreduce(F1, F2, #{}, lists:seq(1, 10)),
    error_logger:info_msg("======mapreduce Result:~p~n", [Result]).

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
    %% Wait for N Map processes to terminate
    Map1 = collect_replies(N, #{}),
    Acc = maps:fold(F2, Acc0, Map1),
    Parent ! {self(), Acc}.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% collect_replies(N, Map) collect and merge {Key, Value} messages from N processese
%%      When N processes have teminated return a {Key, [Value]} tuple
%%
%% @end
%%--------------------------------------------------------------------
collect_replies(0, Map) ->
    Map;
collect_replies(N, Map) ->
    receive
        {Key, Val} ->
            Map1 =
                case maps:get(Key, Map, undefined) of
                    undefined ->
                        Map#{
                            Key => [Val]
                        };
                    Existing ->
                        Map#{
                            Key := [Val | Existing]
                        }
                end,
            collect_replies(N, Map1);
        {'EXIT', _, _Why} ->
            collect_replies(N - 1, Map)
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