%% API
-module(shell1).
-export([start/1]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Jul 2015 9:29 PM
%%%-------------------------------------------------------------------
-author("Li").

start(Browser) ->
	Browser ! [{cmd, append_div}, {id, scroll}, {txt, <<"Starting Erlang shell:<br>">>}],
	running(Browser, erl_eval:new_bindings(), 1).

running(Browser, B0, N) ->
	receive
		{Browser, {struct, [{entry, <<"input">>}, {txt, Bin}]}} ->
			{Value, B1} = string2value(binary_to_list(Bin), B0),
			BV = bf("~w > <font color='red'>~s</font><br>~p<br>", [N, Bin, Value]),
			Browser ! [{cmd, append_div}, {id, scroll}, {txt, BV}],
			io:format("Bindings: ~p~n", [B1]),
			running(Browser, B1, N + 1);
		Error ->
			io:format("Error: ~p~n", [Error])
	end.

string2value(Str, Bindings0) ->
	case erl_scan:string(Str, 0) of
		{ok, Tokens, _} ->
			case erl_parse:parse_exprs(Tokens) of
				{ok, Exprs} ->
					{value, Val, Bindings1} = erl_eval:exprs(Exprs, Bindings0),
					{Val, Bindings1};
				Other ->
					io:format("cannot parse:~p Reason=~p~n", [Tokens, Other]),
					{parse_error, Bindings0}
			end;
		Other ->
			io:format("cannot tokenise:~p Reason=~p~n", [Str, Other])
	end.

bf(F, D) ->
	list_to_binary(io_lib:format(F, D)).