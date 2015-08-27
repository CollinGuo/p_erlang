%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 08. Aug 2015 4:39 PM
%%%-------------------------------------------------------------------
-module(my_bank).
-author("Shuieryin").

-behaviour(gen_server).

%% API
-export([start_link/0,
    stop/0,
    new_account/1,
    deposit/2,
    withdraw/2,
    format_status/2]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec start_link() ->
    {ok, Pid} |
    ignore |
    {error, Reason} when

    Pid :: pid(),
    Reason :: term().
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%--------------------------------------------------------------------
%% @doc
%% Stops the server
%%
%% @end
%%--------------------------------------------------------------------
-spec stop() -> Res when
    Res :: term() | no_return().
stop() ->
    gen_server:call(?MODULE, stop).

%%--------------------------------------------------------------------
%% @doc
%% Create account
%%
%% @end
%%--------------------------------------------------------------------
-spec new_account(Who) -> Res when
    Who :: atom(),
    Res :: term() | no_return().
new_account(Who) ->
    gen_server:call(?MODULE, {new, Who}).

%%--------------------------------------------------------------------
%% @doc
%% Deposit balance
%%
%% @end
%%--------------------------------------------------------------------
-spec deposit(Who, Amount) -> Res when
    Who :: atom(),
    Amount :: non_neg_integer(),
    Res :: term() | no_return().
deposit(Who, Amount) ->
    gen_server:call(?MODULE, {add, Who, Amount}).

%%--------------------------------------------------------------------
%% @doc
%% Withdraw balance
%%
%% @end
%%--------------------------------------------------------------------
-spec withdraw(Who, Amount) -> Res when
    Who :: atom(),
    Amount :: non_neg_integer(),
    Res :: term() | no_return().
withdraw(Who, Amount) ->
    gen_server:call(?MODULE, {remove, Who, Amount}).


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

    Request :: {new, Who} | {add, Who, InputBalance} | {remove, Who, InputBalance} | stop,
    From :: {pid(), Tag},
    Tag :: term(),
    Who :: atom(),
    State :: map(),
    NewState :: map(),
    InputBalance :: non_neg_integer(),
    Balance :: non_neg_integer(),
    NewBalance :: non_neg_integer(),
    Reply :: {welcome, Who} |
    {Who, you_already_are_a_customer} |
    not_a_customer |
    {thanks, Who, your_balance_is, NewBalance} |
    {sorry, Who, you_only_have, Balance, in_the_bank}.
handle_call({new, Who}, _From, State) ->
    Reply = case maps:is_key(Who, State) of
                false ->
                    NewState = maps:put(Who, 0, State),
                    {welcome, Who};
                true ->
                    NewState = State,
                    {Who, you_already_are_a_customer}
            end,
    {reply, Reply, NewState};
handle_call({add, Who, InputBalance}, _From, State) ->
    Reply = case maps:find(Who, State) of
                error ->
                    NewState = State,
                    not_a_customer;
                {ok, Balance} ->
                    NewBalance = Balance + InputBalance,
                    NewState = maps:update(Who, NewBalance, State),
                    {thanks, Who, your_balance_is, NewBalance}
            end,
    {reply, Reply, NewState};
handle_call({remove, Who, InputBalance}, _From, State) ->
    Reply = case maps:find(Who, State) of
                error ->
                    NewState = State,
                    not_a_customer;
                {ok, Balance} when InputBalance =< Balance ->
                    NewBalance = Balance - InputBalance,
                    NewState = maps:update(Who, NewBalance, State),
                    {thanks, Who, your_balance_is, NewBalance};
                {ok, Balance} ->
                    NewState = State,
                    {sorry, Who, you_only_have, Balance, in_the_bank}
            end,
    {reply, Reply, NewState};
handle_call(stop, _From, State) ->
    {stop, normal, stopped, State}.

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
