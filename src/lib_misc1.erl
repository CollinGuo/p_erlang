%% @author Administrator
%% @doc @todo Add description to lib_misc.


-module(lib_misc1).

%% ====================================================================
%% API functions
%% ====================================================================
-import(mylists, [map/2]).
-export([pmap1/2]).


%% ====================================================================
%% Internal functions
%% ====================================================================
%% lib_misc1:pmap1(fun(X) -> 2*X end, [1,2,3,4,5,6,7]).

pmap1(F, L) ->
    S = self(),
    Ref = erlang:make_ref(),
    lists:foreach(fun(I) ->
        spawn(fun() ->
            %% S ! {Ref, (catch F(I))}
            do_f1(S, Ref, F, I)
        end)
    end,
        L),
    %% gather the results
    gather1(length(L), Ref, []).

do_f1(Parent, Ref, F, I) ->
    Parent ! {Ref, (catch F(I))}.

gather1(0, _, L) ->
    L;
gather1(N, Ref, L) ->
    receive
        {Ref, Ret} ->
            gather1(N - 1, Ref, [Ret | L])
    end.
