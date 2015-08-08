%% API
-module(lib_misc).
-export([testa/1,
    create_file/0,
    start/0,
    for/3,
    qasort/1,
    qdsort/1,
    qsort/2,
    pythag/1,
    perms/1,
    max/2,
    filter1/2,
    odds_and_evens1/1,
    odds_and_evens2/1,
    my_tuple_to_list/1,
    now_milli/0,
    my_date_string/0,
    my_time_func/0,
    my_read_json_to_map/2,
    pmap1/2,
    qsortFun/1,
    pmap/2,
    sleep/1,
    flush_buffer/0,
    priority_receive/0,
    on_exit/2,
    start/1,
    keep_alive/2,
    string2value/1,
    delibrate_error/1,
    delibrate_error1/1,
    delibrate_error2/1,
    glurk/2,
    dump/2]).
-import(erl_scan, [string/1]).
-import(erl_parse, [parse_exprs/1]).
-import(erl_eval, [exprs/2, new_bindings/0]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Apr 2015 5:56 PM
%%%-------------------------------------------------------------------
-author("Li").

-define(NYI(X), (begin
                     io:format("*** NYI ~p ~p ~p~n", [?MODULE, ?LINE, X]),
                     exit(nyi)
                 end)).

start() ->
    L = [6, 2, 9, 27, 400, 78, 45, 61, 82, 14, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82, 2, 9, 27, 400, 78, 45, 61, 82],
    qsort(L, asc).
%% 	T = {a, b, c, d, e},
%% 	erlang:display(my_tuple_to_list(T)).

for(Max, Max, F) ->
    [F(Max)];
for(I, Max, F) ->
    [F(I) | for(I + 1, Max, F)].

qsort(TargetList, Mode) ->
    case Mode of
        asc ->
            qasort(TargetList);
        desc ->
            qdsort(TargetList)
    end.

%% ascending sort
qasort([]) ->
    [];
qasort([Pivot | T]) ->
    qasort([X || X <- T, X < Pivot])
    ++ [Pivot] ++
        qasort([X || X <- T, X >= Pivot]).

%% descending sort
qdsort([]) ->
    [];
qdsort([Pivot | T]) ->
    qdsort([X || X <- T, X >= Pivot])
    ++ [Pivot] ++
        qdsort([X || X <- T, X < Pivot]).

%% Steps for ascending qsort[3,5,2,4,1].
%% 1 - qsort([3 | [5,2,4,1]]) ->
%% 		qsort([2,1])
%% 		++ [3] ++
%% 		qsort([5,4]).
%% 2 - qsort([2|[1]]) ->
%% 		qsort([1])
%% 		++ [2] ++
%% 		qsort([]).
%% 3 - qsort([5|[4]]) ->
%% 		qsort([4])
%% 		++ [5] ++
%% 		qsort([]).
%% 4 - step2 + step1 + step3 => [1] ++ [2] ++ [] ++ [3] ++ [4] ++ [5] ++ [].
%%
%% 5 - [1,2,3,4,5].

pythag(N) ->
    [{A, B, C} ||
        A <- lists:seq(1, N),
        B <- lists:seq(1, N),
        C <- lists:seq(1, N),
        A + B + C =< N,
        A * A + B * B =:= C * C
    ].

perms([]) ->
    [[]];
perms(List) ->
    [[Head | Tail] || Head <- List, Tail <- perms(List--[Head])].

%% Steps for perms("123")
%% 1 - [1, perms("23")] -> [2, perms("3")] -> [3, perms([])] => 123
%% 						[3, perms("2")] -> [2, perms([])] => 132
%% 2 - [2, perms("13")] -> [1, perms("3")] -> [3, perms([])] => 213
%% 						[3, perms("1")] -> [1, perms([])] => 231
%% 3 - [3, perms("12")] -> [1, perms("2")] -> [2, perms([])] => 312
%% 						[2, perms("1")] -> [1, perms([])] => 321
%% final output ["123", "132", "213", "231", "312", "321"].

max(X, Y) when is_integer(X), is_integer(Y), X > Y ->
    X;
max(X, Y) when is_integer(X), is_integer(Y) ->
    Y.

filter1(Func, [Head | Tail]) ->
    case Func(Head) of
        true ->
            [Head | filter1(Func, Tail)];
        false ->
            filter1(Func, Tail)
    end;
filter1(_, []) ->
    [].

odds_and_evens1(List) ->
    Odds = [Odd || Odd <- List, Odd rem 2 =:= 1],
    Evens = [Even || Even <- List, Even rem 2 =:= 0],
    {Odds, Evens}.

odds_and_evens2(List) ->
    odds_and_evens_acc(List, [], []).

odds_and_evens_acc([Head | Tail], Odds, Evens) ->
    case (Head rem 2) of
        1 ->
            odds_and_evens_acc(Tail, [Head | Odds], Evens);
        0 ->
            odds_and_evens_acc(Tail, Odds, [Head | Evens])
    end;
odds_and_evens_acc([], Odds, Evens) ->
    {Odds, Evens}.

my_tuple_to_list(Tuple) ->
    my_tuple_to_list_acc(size(Tuple), Tuple, []).

my_tuple_to_list_acc(0, _, List) ->
    List;
my_tuple_to_list_acc(Count, Tuple, List) when is_integer(Count), is_tuple(Tuple), is_list(List) ->
    TailElement = element(Count, Tuple),
    my_tuple_to_list_acc(Count - 1, Tuple, [TailElement | List]).

now_milli() ->
    {MegaSecs, Secs, MicroSecs} = erlang:timestamp(),
    (MegaSecs * 1000000 + Secs) * 1000 + MicroSecs div 1000.

my_date_string() ->
    {Year, Month, Day} = date(),
    {Hour, Minute, Second} = time(),
    erlang:display(Hour ++ ":" ++ Minute ++ ":" ++ Second ++ "," ++ Year ++ "-" ++ Month ++ "-" ++ Day).

my_time_func() ->
    StartTime = erlang:timestamp(),
    start(),
    erlang:display(timer:now_diff(erlang:timestamp(), StartTime)).

%% count_characters(Str) ->
%% 	count_characters_acc(Str, #{}, 0).
%%
%% count_characters_acc([], ResultMap, _) ->
%% 	ResultMap;
%% count_characters_acc([Head | Tail], CalcMap, Value) ->
%% 	count_characters_acc(Tail, CalcMap#{Head=>Value + 1});
%% count_characters_acc([Head | Tail], CalcMap, 0) ->
%% 	count_characters_acc(Tail, CalcMap#{Head=>1}).

my_read_json_to_map(Dir, FileName) ->
    JsonFilePath = filename:join(Dir, FileName),
    JsonFile = file:read_file(JsonFilePath),
    case JsonFile of
        {ok, Content} ->
            Content; %% maps:from_json is not available in Erlang 17
        {error, ErrorCode} ->
            ErrorCode
    end.

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
    end, L),
    %% gather the results
    gather1(length(L), Ref, [numbers]).

do_f1(Parent, Ref, F, I) ->
    Parent ! {Ref, (catch F(I))}.

gather1(0, _, L) ->
    L;
gather1(N, Ref, L) ->
    receive
        {Ref, Ret} ->
%% 			[Ret | gather1(N - 1, Ref, L)]  %% ascending
            gather1(N - 1, Ref, [Ret | L])  %% descending
    end.

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

create_file() ->
    unconsult("test1.dat", [{cats, ["zorrow", "daisy"]}, {weather, snowing}]).
unconsult(File, L) ->
    {ok, S} = file:open(File, write),
    lists:foreach(
        fun(X) ->
            io:format(S, "~p.~n", [X])
        end,
        L
    ),
    file:close(S).

sleep(T) ->
    receive
    after
        T ->
            true
    end.

flush_buffer() ->
    receive
        _Any ->
            flush_buffer()
    after
        0 ->
            true
    end.

%% Note: Using large mailboxes with priority receive is rather inefficient,
%% so if you're going to use this technique, make sure your mailboxes are not too large.
priority_receive() ->
    receive
        {alarm, X} ->
            {alarm, X}
    after
        0 ->
            receive
                Any ->
                    Any
            end
    end.

on_exit(Pid, Fun) ->
    spawn(
        fun() ->
            Ref = monitor(process, Pid),
            receive
                {'DOWN', Ref, process, Pid, Why} ->
                    Fun(Why)
            end
        end
    ).

start(Fs) ->
    spawn(
        fun() ->
            [spawn_link(F) || F <- Fs],
            receive
            after
                infinity ->
                    true
            end
        end
    ).

keep_alive(Name, Fun) ->
    register(Name, Pid = spawn(Fun)),
    on_exit(
        Pid,
        fun(_Why) ->
            keep_alive(Name, Fun)
        end
    ).

testa([]) ->
    io:format("done~n");
testa([Head | Tail]) ->
    io:format("~p~n", [Head]),
    testa(Tail).

string2value(Str) ->
    {ok, Tokens, _} = string(Str ++ "."),
    {ok, Exprs} = parse_exprs(Tokens),
    Bindings = new_bindings(),
    {value, Value, _} = exprs(Exprs, Bindings),
    Value.

delibrate_error(A) ->
    bad_function(A, 12),
    lists:reverse(A).

delibrate_error1(A) ->
    lists:reverse(A),
    bad_function(A, 12).

delibrate_error2(A) ->
    delibrate_error1(A),
    lists:reverse(A).

bad_function(A, _) ->
    {ok, Bin} = file:open({abc, 123}, A),
    binary_to_list(Bin).

glurk(X, Y) ->
    ?NYI({glurk, X, Y}).

%% lib_misc:dump("dump",[1,2,3,4,5,6]).
dump(File, Term) ->
    Out = File ++ ".tmp",
    io:format("** dumping to ~s~n", [Out]),
    {ok, S} = file:open(Out, [write]),
    io:format(S, "~p.~n", [Term]),
    file:close(S).