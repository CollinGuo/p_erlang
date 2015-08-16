-module(test_mapreduce).
%% API
-export([test/0]).
-import(lists, [reverse/1, sort/1]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Aug 2015 3:29 PM
%%%-------------------------------------------------------------------
-author("Li").

%%%===================================================================
%%% API
%%%===================================================================

test() ->
    wc_dir("./src/practices").

wc_dir(Dir) ->
    F1 = fun generate_words/2,
    F2 = fun count_words/3,
    Files = lib_find:files(Dir, "*.erl", false),
    L1 = phofs:mapreduce(F1, F2, [], Files),
    reverse(sort(L1)).

generate_words(Pid, File) ->
    F = fun(Word) ->
        Pid ! {Word, 1}
    end,
    Result = lib_misc:foreachWordInFile(File, F),
    Result.

count_words(Key, Vals, A) ->
    [{length(Vals), Key} | A].

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Comment starts here
%%
%% @end
%%--------------------------------------------------------------------
