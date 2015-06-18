%% API
-module(rpc_test).
-export([being_called/0]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Jun 2015 9:11 PM
%%%-------------------------------------------------------------------
-author("Li").

%% Key = rpc:async_call('col@192.168.1.103', rpc_test, being_called, []).
%% io:format("~p~n", [rpc:yield(Key)]).

being_called() ->
	io:format("~p~n", ["I'm being called."]),
	timer:sleep(3000),
	hi_there.