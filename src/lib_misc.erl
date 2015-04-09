%% @author Administrator
%% @doc @todo Add description to lib_misc.


-module(lib_misc).

%% ====================================================================
%% API functions
%% ====================================================================
-export([pmap/2, for/3, qsort/1, qsortFun/1]).


%% ====================================================================
%% Internal functions
%% ====================================================================
%% lib_misc:pmap(fun(X) -> 2*X end, [1,2,3,4,5,6,7]).

pmap(CusFunc, List) ->
    PmapPid = self(),
    Reference = erlang:make_ref(),
    CalcPids = map(fun(Factor) ->
        spawn(fun() ->
            %% PmapPid ! {self(), Reference, (catch CusFunc(Factor))}
            do_func(PmapPid, Reference, CusFunc, Factor)
        end)
    end,
        List),
    %% gather results
    gather(CalcPids, Reference).

map(_, []) ->
    [];
map(SpawnFunc, [Factor | TailList]) ->
    [SpawnFunc(Factor) | map(SpawnFunc, TailList)].

do_func(PmapPid, Reference, CusFunc, Factor) ->
    PmapPid ! {self(), Reference, (catch CusFunc(Factor))}.

gather([SyncPid | TailCalcPids], Reference) ->
    receive
        {SyncPid, Reference, CalcedValue} ->
            [CalcedValue | gather(TailCalcPids, Reference)]
    end;
gather([], _) ->
    [].

for(Max, Max, F) ->
    [F(Max)];
for(I, Max, F) ->
    [F(I) | for(I + 1, Max, F)].

qsort([]) ->
    [];
qsort([Pivot | T]) ->
    qsort([X || X <- T, X < Pivot])
    ++ [Pivot] ++
        qsort([X || X <- T, X >= Pivot]).

mathComp(lt, X, Pivot) ->
    X < Pivot;
mathComp(gt, X, Pivot) ->
    X >= Pivot.

qsortFun([]) ->
    [];
qsortFun([Pivot | T]) ->
    qsort([X || X <- T, mathComp(lt, X, Pivot)])
    ++ [Pivot] ++
        qsort([X || X <- T, mathComp(gt, X, Pivot)]).
