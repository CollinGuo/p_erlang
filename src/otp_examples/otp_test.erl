%%%-------------------------------------------------------------------
%%% @author shuieryin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 九月 2015 下午3:53
%%%-------------------------------------------------------------------
-module(otp_test).
-author("shuieryin").

-behaviour(gen_server).

%% API
-export([start_links/0,
    test/2,
    show_state/1,
    pmap/2,
    gen_n_num_list/2,
    run_test/3,
    gen_row_col/1,
    main/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3,
    format_status/2]).

-define(SERVER, ?MODULE).
-define(SERVER_NUM, 1).
-define(SLEEP_TIME, 1).

main() ->
    start_links(),
    otp_test_s:start_link().

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec start_links() ->
    {ok, Pid} |
    ignore |
    {error, Reason} when

    Pid :: pid(),
    Reason :: term().
start_links() ->
    [gen_server:start_link({local, server_name(ServerCounter)}, ?MODULE, [], []) || ServerCounter <- lists:seq(1, ?SERVER_NUM)].

server_name(Counter) ->
    list_to_atom(atom_to_list(?MODULE) ++ integer_to_list(Counter)).

test(Grand, ExeTime) ->
    Fun = fun({CurRow, CurCol}) -> run_test(CurRow, CurCol, ExeTime) end,
    ResultList = lists:map(Fun, gen_row_col(Grand)),
    {Row, Col, SpentTime} = find_fastest(ResultList, 0, {}),
    io:format("Fastest pattern:~p * ~p~nspent~nmicro seconds:~p~nmilli seconds:~p~nseconds:~p~n~n", [Row, Col, SpentTime, SpentTime / 1000, SpentTime / 1000 / 1000]).

find_fastest([], _, Result) ->
    Result;
find_fastest([Head | Tail], Time, Result) ->
    {_, _, SpentTime} = Head,
    {NewResult, NewSpentTime} = if
                                    SpentTime < Time orelse Time == 0 ->
                                        {Head, SpentTime};
                                    SpentTime >= Time ->
                                        {Result, Time}
                                end,
    find_fastest(Tail, NewSpentTime, NewResult).

gen_row_col(Row) ->
    [{round(Row / Col), Col} || Col <- lists:seq(1, Row), Row rem Col =:= 0].

run_test(Row, Col, _ExeTime) ->
    Fun = fun({Num, ServerCounter}) ->
        gen_server:call(server_name(ServerCounter), {test, Num})
    end,
    L = gen_n_num_list(Row, Col),
    pmap(Fun, L).
%%     {SpentTime, _} = timer:tc(?MODULE, pmap, [Fun, L]),
%%     io:format("SpentTime:~p~n", [SpentTime / 1000 / 1000]).
%%     SpentTime = test_n_times(ExeTime, Fun, L),
%%     {SpentTime, _} = timer:tc(?MODULE, pmap, [Fun, L]),
%%     show_state(),
%%     io:format("Pattern:~p * ~p~nspent~nmicro seconds:~p~nmilli seconds:~p~nseconds:~p~n~n", [Row, Col, SpentTime, SpentTime / 1000, SpentTime / 1000 / 1000]),
%%     {Row, Col, SpentTime}.

%% test_n_times(ExeTime, Fun, L) ->
%%     FoldFun = fun(_, AccTime) ->
%%         SpentTime = pmap(Fun, L),
%%         AccTime + SpentTime
%%     end,
%%     TotalTime = lists:foldl(FoldFun, 0, lists:seq(1, ExeTime)),
%%     round(TotalTime / ExeTime).

gen_n_num_list(RowNum, ColNum) ->
    [lists:seq(CurRowNum * ColNum, CurRowNum * ColNum + ColNum - 1) || CurRowNum <- lists:seq(1, RowNum)].

%% gen_num_list(StartNum, EndNum, L) when StartNum =:= EndNum ->
%%     L;
%% gen_num_list(StartNum, EndNum, L) ->
%%     gen_num_list(StartNum - 1, EndNum, [StartNum] ++ L).

show_state(Num) ->
    io:format("State:~p~n", [gen_server:call(server_name(Num), get_state)]).

pmap(CusFunc, List) ->
%%     PmapPid = self(),
    Reference = erlang:make_ref(),
    StartTime = erlang:system_time(),
    lists:foreach(fun(Factor) ->
        spawn(fun() ->
            FoldFun = fun(Value, {ServerCounter}) ->
                apply(CusFunc, [{Value, ServerCounter}]),
                NewServerCounter = case ServerCounter + 1 of
                                       ?SERVER_NUM + 1 ->
                                           1;
                                       Nsc ->
                                           Nsc
                                   end,
                {NewServerCounter}
            end,
            lists:foldl(FoldFun, {1}, Factor),
            otp_test_s:count_time(StartTime)
        end)
    end,
        List),
    Reference.
%% gather results
%%     gather(CalcPids, Reference, 0).

%% map(_, []) ->
%%     [];
%% map(SpawnFunc, [Factor | TailList]) ->
%%     [SpawnFunc(Factor) | map(SpawnFunc, TailList)].

%% do_func(_PmapPid, _Reference, CusFunc, Factor) ->
%%     io:format("Factor:~p~n", [Factor]),
%%     FoldFun = fun(Value, {ServerCounter, AccSpentTime}) ->
%%         {SpentTime, _} = timer:tc(CusFunc, [{Value, ServerCounter}]),
%%         NewServerCounter = case ServerCounter + 1 of
%%                                ?SERVER_NUM + 1 ->
%%                                    1;
%%                                Nsc ->
%%                                    Nsc
%%                            end,
%%         {NewServerCounter, AccSpentTime + SpentTime}
%%     end,
%%     {_, TotalSpentTime} = lists:foldl(FoldFun, {1, 0}, Factor),
%%     FoldFun = fun(Value, {ServerCounter}) ->
%%         apply(CusFunc, [{Value, ServerCounter}]),
%%         NewServerCounter = case ServerCounter + 1 of
%%                                ?SERVER_NUM + 1 ->
%%                                    1;
%%                                Nsc ->
%%                                    Nsc
%%                            end,
%%         {NewServerCounter}
%%     end,
%%     io:format("Here2~n"),
%%     {TotalSpentTime, _} = timer:tc(lists, foldl, [FoldFun, {1}, Factor]),
%%     io:format("SpentTime:~p~n", [TotalSpentTime / 1000 / 1000]),
%%     otp_test_s:add_time(_Reference, TotalSpentTime).
%%     lists:foldl(FoldFun, {1}, Factor).


%%     PmapPid ! {self(), Reference, SpentTime}.

%% gather([SyncPid | TailCalcPids], Reference, AccSpentTime) ->
%%     receive
%%         {SyncPid, Reference, SpentTime} ->
%%             gather(TailCalcPids, Reference, AccSpentTime + SpentTime)
%%     end;
%% gather([], _, TotalSpentTime) ->
%%     TotalSpentTime.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec init(Args) ->
    {ok, State} |
    {ok, State, timeout() | hibernate} |
    {stop, Reason} |
    ignore when

    Args :: term(),
    State :: map(),
    Reason :: term().
init([]) ->
    {ok, #{}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec handle_call(Request, From, State) ->
    {reply, Reply, NewState} |
    {reply, Reply, NewState, timeout() | hibernate} |
    {noreply, NewState} |
    {noreply, NewState, timeout() | hibernate} |
    {stop, Reason, Reply, NewState} |
    {stop, Reason, NewState} when

    Request :: {test, Time} | get_state,
    Time :: integer(),
    From :: {pid(), Tag :: term()},
    Reply :: term(),
    State :: map(),
    NewState :: map(),
    Reason :: term().
handle_call({test, Time}, _From, State) ->
%%     RandomNum = random:uniform(Time),
%%     io:format("Here3~n"),
    timer:sleep(?SLEEP_TIME),
%%     io:format("Here4~n"),
    {reply, Time, State#{Time => Time}};
handle_call(get_state, _From, State) ->
    {reply, State, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec handle_cast(Request, State) ->
    {noreply, NewState} |
    {noreply, NewState, timeout() | hibernate} |
    {stop, Reason, NewState} when

    Request :: term(),
    State :: map(),
    NewState :: map(),
    Reason :: term().
handle_cast(_Request, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec handle_info(Info | term(), State) ->
    {noreply, NewState} |
    {noreply, NewState, timeout() | hibernate} |
    {stop, Reason, NewState} when

    Info :: timeout(),
    State :: map(),
    NewState :: map(),
    Reason :: term().
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec terminate(Reason, State) -> term() when
    Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: map().
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec code_change(OldVsn, State, Extra) ->
    {ok, NewState} |
    {error, Reason} when

    OldVsn :: term() | {down, term()},
    State :: map(),
    Extra :: term(),
    NewState :: map(),
    Reason :: term().
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is useful for customising the form and
%% appearance of the gen_server status for these cases.
%%
%% @spec format_status(Opt, StatusData) -> Status
%% @end
%%--------------------------------------------------------------------
-spec format_status(Opt, StatusData) -> Status when
    Opt :: 'normal' | 'terminate',
    StatusData :: [PDict | State],
    PDict :: [{Key :: term(), Value :: term()}],
    State :: term(),
    Status :: term().
format_status(Opt, StatusData) ->
    gen_server:format_status(Opt, StatusData).

%%%===================================================================
%%% Internal functions
%%%===================================================================
