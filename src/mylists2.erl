%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Apr 2015 6:21 PM
%%%-------------------------------------------------------------------
-module(mylists2).
-author("Li").

%% API
-export([pmap/2, sum/1, map/2]).

pmap(Func, List) ->
	Self = self(),
	%% make_ref() returns a unique reference, we'll match on this later
	%% Ref is going to be used in other purpose
	Ref = make_ref(),

	SpawnFunc = fun(I) ->
		spawn(fun() ->
			do_f(Self, Ref, Func, I)
		end)
	end,

	Pids = map(SpawnFunc, List),
	gather(Pids, Ref).

do_f(Parent, Ref, Func, I) ->
	Parent ! {self(), Ref, (catch Func(I))}.

gather([Pid | Tail], Ref) ->
	receive
		{Pid, Ref, Ret} ->
			[Ret | gather(Tail, Ref)]
	end;
gather([], _) ->
	[].

sum([Head | Tail]) ->
	Head + sum(Tail);
sum([]) ->
	0.

map(Func, [Head | Tail]) ->
	[Func(Head) | map(Func, Tail)];
map(_, []) ->
	[].
