%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Aug 2015 8:57 PM
%%%-------------------------------------------------------------------
-module(my_alarm_handler).
-author("Li").

-behaviour(gen_event).

%% API
-export([start_link/0,
    add_handler/0]).

%% gen_event callbacks
-export([init/1,
    handle_event/2,
    handle_call/2,
    handle_info/2,
    terminate/2,
    code_change/3,
    format_status/2]).

-define(SERVER, ?MODULE).
-define(FAN_ON, fan_on).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Creates an event manager
%%
%% @end
%%--------------------------------------------------------------------
-spec start_link() ->
    {ok, pid()} | {error, {already_started, pid()}}.
start_link() ->
    gen_event:start_link({local, ?SERVER}).

%%--------------------------------------------------------------------
%% @doc
%% Adds an event handler
%%
%% @end
%%--------------------------------------------------------------------
-spec add_handler() ->
    ok |
    {'EXIT', Reason} |
    term() when

    Reason :: term().
add_handler() ->
    gen_event:add_handler(?SERVER, ?MODULE, []).

%%%===================================================================
%%% gen_event callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a new event handler is added to an event manager,
%% this function is called to initialize the event handler.
%%
%% @end
%%--------------------------------------------------------------------
-spec init(InitArgs) ->
    {ok, State} |
    {ok, State, hibernate} |
    {error, Reason} when

    InitArgs :: term(),
    State :: map(),
    Reason :: term().
init(InitArgs) ->
    io:format("*** my_alarm_handler init:~p~n", [InitArgs]),
    {ok, #{?FAN_ON => 0}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever an event manager receives an event sent using
%% gen_event:notify/2 or gen_event:sync_notify/2, this function is
%% called for each installed event handler to handle the event.
%%
%% @end
%%--------------------------------------------------------------------
-spec handle_event(Event, State) ->
    {ok, NewState} |
    {ok, NewState, hibernate} |
    {swap_handler, Args1, NewState, Handler2, Args2} |
    remove_handler when

    Event :: {set_alarm | clear_alarm, tooHot},
    State :: map(),
    NewState :: map(),
    Args1 :: term(),
    Args2 :: term(),
    Id :: term(),
    Handler2 :: (atom() | {atom(), Id}).
handle_event({set_alarm, tooHot}, State) ->
    error_logger:error_msg("*** Tell the Engineer to turn on the fan~n"),
    {ok, maps:update(?FAN_ON, 1, State)};
handle_event({clear_alarm, tooHot}, State) ->
    error_logger:error_msg("*** Danger over. Turn off the fan~n"),
    {ok, maps:update(?FAN_ON, 0, State)};
handle_event(Event, State) ->
    io:format("*** unmatched event:~p~n", [Event]),
    {ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever an event manager receives a request sent using
%% gen_event:call/3,4, this function is called for the specified
%% event handler to handle the request.
%%
%% @end
%%--------------------------------------------------------------------
-spec handle_call(Request, State) ->
    {ok, Reply, NewState} |
    {ok, Reply, NewState, hibernate} |
    {swap_handler, Reply, Args1, NewState, Handler2, Args2} |
    {remove_handler, Reply} when

    Request :: term(),
    State :: map(),
    NewState :: map(),
    Reply :: term(),
    Args1 :: term(),
    Args2 :: term(),
    Id :: term(),
    Handler2 :: (atom() | {atom(), Id}).
handle_call(_Request, State) ->
    Reply = ok,
    {ok, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called for each installed event handler when
%% an event manager receives any other message than an event or a
%% synchronous request (or a system message).
%%
%% @end
%%--------------------------------------------------------------------
-spec handle_info(Info, State) ->
    {ok, NewState} |
    {ok, NewState, hibernate} |
    {swap_handler, Args1, NewState, Handler2, Args2} |
    remove_handler when

    Info :: term(),
    State :: map(),
    NewState :: map(),
    Args1 :: term(),
    Args2 :: term(),
    Id :: term(),
    Handler2 :: (atom() | {atom(), Id}).
handle_info(_Info, State) ->
    {ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever an event handler is deleted from an event manager, this
%% function is called. It should be the opposite of Module:init/1 and
%% do any necessary cleaning up.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec terminate(Args, State) -> term() when
    Reason :: term(),
    State :: term(),
    Args :: (term() | {stop, Reason} | stop | remove_handler | {error, {'EXIT', Reason}} | {error, term()}).
terminate(_Arg, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @end
%%--------------------------------------------------------------------
-spec code_change(OldVsn, State, Extra) -> {ok, NewState} when
    OldVsn :: term() | {down, term()},
    State :: map(),
    NewState :: map(),
    Extra :: term().
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
    gen_event:format_status(Opt, StatusData).

%%%===================================================================
%%% Internal functions
%%%===================================================================
