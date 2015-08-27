-module(code_lock).
-behaviour(gen_fsm).
%% API
-export([start_link/1]).
-export([button/1]).
-export([init/1, locked/2, open/2]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Aug 2015 8:50 PM
%%%-------------------------------------------------------------------
-author("Li").

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Comment starts here
%%
%% @end
%%--------------------------------------------------------------------
start_link(Code) ->
    gen_fsm:start_link({local, code_lock}, code_lock, lists:reverse(Code), []).

button(Digit) ->
    gen_fsm:send_event(code_lock, {button, Digit}).

init(Code) ->
    {ok, locked, {[], Code}}.

locked({button, Digit}, {SoFar, Code}) ->
    case [Digit | SoFar] of
        Code ->
            do_unlock(),
            {next_state, open, {[], Code}, 30000};
        Incomplete when length(Incomplete) < length(Code) ->
            {next_state, locked, {Incomplete, Code}};
        _Wrong ->
            {next_state, locked, {[], Code}}
    end.

open(timeout, State) ->
    do_lock(),
    {next_state, locked, State}.

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
do_unlock() ->
    done.

do_lock() ->
    done.