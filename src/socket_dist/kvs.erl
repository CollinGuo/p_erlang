%% API
-module(kvs).
-export([start/0, store/2, lookup/1]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2015 9:58 PM
%%%-------------------------------------------------------------------
-author("Li").

-spec kvs:start() -> true.
start() ->
	register(kvs, spawn(
		fun() ->
			loop()
		end)).

-spec kvs:store(Key, Value) -> true when
	Key :: atom(),
	Value :: term().
store(Key, Value) ->
	rpc({store, Key, Value}).

-spec kvs:lookup(Key) -> {ok, Value} | undefined when
	Key :: atom(),
	Value :: term().
lookup(Key) ->
	rpc({lookup, Key}).

rpc(Q) ->
	kvs ! {self(), Q},
	receive
		{kvs, Reply} ->
			Reply
	end.

loop() ->
	receive
		{From, {store, Key, Value}} ->
			put(Key, {ok, Value}),
			From ! {kvs, true};
		{From, {lookup, Key}} ->
			From ! {kvs, get(Key)}
	end,
	loop().