%% API
-module(types1).
-export([f1/1, f2/1, f3/1, f4/1, myand1/2, bug1/2]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. May 2015 3:15 PM
%%%-------------------------------------------------------------------
-author("Li").

%% cmds
%% dialyzer types1.erl
%% typer types1.erl

-spec f1({number(), number(), number()}) ->
	number().
f1({H, M, S}) ->
	(H + M * 60) * 60 + S.

-spec f2({integer(), number(), number()}) ->
	number().
f2({H, M, S}) when is_integer(H) ->
	(H + M * 60) * 60 + S.

-spec f3({integer(), integer(), integer()}) ->
	integer().
f3({H, M, S}) ->
	print(H, M, S),
	(H + M * 60) * 60 + S.

f4({H, M, S}) -> % when is_float(H)
	print(H, M, S),
	(H + M * 60) * 60 + S.

-spec print(integer(), integer(), integer()) ->
	'ok'.
print(H, M, S) ->
	Str = integer_to_list(H) ++ ":" ++ integer_to_list(M) ++ ":" ++ integer_to_list(S),
	io:format("~s", [Str]).

myand1(true, true) ->
	true;
myand1(false, _) ->
	false;
myand1(_, false) ->
	false.

bug1(X, Y) ->
	case myand1(X, Y) of
		true ->
			X + Y
	end.
