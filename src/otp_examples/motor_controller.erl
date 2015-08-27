-module(motor_controller).
%% API
-export([add_event_handler/0]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 09. Aug 2015 10:43 AM
%%%-------------------------------------------------------------------
-author("Shuieryin").

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Add event handler
%%
%% @end
%%--------------------------------------------------------------------
-spec add_event_handler() -> no_return().
add_event_handler() ->
    event_handler:add_handler(errors, fun controller/1).

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Ignore or turn off the motor if it's overheated
%%
%% @end
%%--------------------------------------------------------------------
controller(too_hot) ->
    io:format("Turn off the motor~n");
controller(X) ->
    io:format("~w ignored event: ~p~n", [?MODULE, X]).