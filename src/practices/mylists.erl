%% @author Administrator
%% @doc @todo Add description to mylists.


-module(mylists).

%% ====================================================================
%% API functions
%% ====================================================================
-export([pmap/2, map/2, sum/1, map1/2, sum1/1]).


%% ====================================================================
%% Internal functions
%% ====================================================================


map(_, []) ->
	[];
map(F, [H | T]) ->
	[F(H) | map(F, T)].

sum([H | T]) ->
	H + sum(T);
sum([]) ->
	0.

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

sum1([Head | Tail]) ->
	Head + sum1(Tail);
sum1([]) ->
	0.

map1(Func, [Head | Tail]) ->
	[Func(Head) | map1(Func, Tail)];
map1(_, []) ->
	[].