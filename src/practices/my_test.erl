%% @author GLMAC
%% @doc @todo Add description to my_test.


-module(my_test).

%% ====================================================================
%% API functions fsdfsdf
%% ====================================================================
-export([change/2, mergeList/2, minusList/2]).


%% ====================================================================
%% Internal functions fdsadf
%% ====================================================================

change([X | Y], L) ->
    Rel = fun(Z) -> Z =:= X end,
    M = lists:filter(Rel, L),
    io:format("~w~n", [M]),
    change(Y, L);
change([], _) ->
    pass.

mergeList([H | T], L) ->
    mergeList(T, [H | L]);
mergeList([], L) ->
    L.

minusList([H | T], L) ->
    minusList(T, [E || E <- L, E =/= H]);
minusList([], L) ->
    L.