-module(event_handler).
%% API
-export([make/1,
    add_handler/2,
    event/2]).


%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 09. Aug 2015 10:41 AM
%%%-------------------------------------------------------------------
-author("Shuieryin").

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Make a "do nothing" event handler called Name (an atom). This provides
%% a place to send events to.
%%
%% @end
%%--------------------------------------------------------------------
-spec make(Name) ->
    true |
    no_return() when

    Name :: term().
make(Name) ->
    register(Name, spawn(
        fun() ->
            my_handler(fun no_op/1)
        end
    )).

%%--------------------------------------------------------------------
%% @doc
%% Add a handler Fun to the event handler called Name. Now when an event X
%% occurs, the event handler will evaluate Fun(X).
%%
%% @end
%%--------------------------------------------------------------------
-spec add_handler(Name, Fun) -> no_return() when
    Name :: term(),
    Fun :: function().
add_handler(Name, Fun) ->
    Name ! {add, Fun}.

%%--------------------------------------------------------------------
%% @doc
%% Send the event X to the event handler called Name.
%%
%% @end
%%--------------------------------------------------------------------
-spec event(Name, X) -> no_return() when
    Name :: term(),
    X :: any().
event(Name, X) ->
    Name ! {event, X}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% My event hanlder
%%
%% @end
%%--------------------------------------------------------------------
my_handler(Fun) ->
    receive
        {add, Fun1} ->
            my_handler(Fun1);
        {event, Any} ->
            (catch Fun(Any)),
            my_handler(Fun)
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% No operation
%%
%% @end
%%--------------------------------------------------------------------
no_op(_) ->
    void.