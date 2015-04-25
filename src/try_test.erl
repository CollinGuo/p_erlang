%% API
-module(try_test).
-export([generate_exception/1, demo1/0, demo2/0, sqrt/1, demo3/0, demo4/0, demo5/0, my_read_file/1]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Apr 2015 2:07 PM
%%%-------------------------------------------------------------------
-author("Li").

generate_exception(1) ->
	a;
generate_exception(2) ->
	throw(a);
generate_exception(3) ->
	exit(a);
generate_exception(4) ->
	{'EXIT', a};
generate_exception(5) ->
	error(5).

demo1() ->
	[catcher(I) || I <- [1, 2, 3, 4, 5]].

catcher(N) ->
	try generate_exception(N) of
		Val ->
			{N, normal, Val}
	catch
		throw:X ->
			{N, caught, thrown, X};
		exit:X ->
			{N, caught, exited, X};
		error:X ->
			{N, caught, error, X}
	after
		done
	end.

demo2() ->
	[{I, (catch generate_exception(I))} || I <- [1, 2, 3, 4, 5]].

sqrt(X) when X < 0 ->
	error({squareRootNegativeArgument, X});
sqrt(X) ->
	math:sqrt(X).

demo3() ->
	[catcher_anything(I) || I <- [1, 2, 3, 4, 5]].

catcher_anything(N) ->
	try generate_exception(N) of
		Val ->
			{N, normal, Val}
	catch
		_:X ->
			{N, caught, anything, X}
	end.

demo4() ->
	[catcher_anything1(I) || I <- [1, 2, 3, 4, 5]].

catcher_anything1(N) ->
	try generate_exception(N) of
		Val ->
			{N, normal, Val}
	catch
		_:_ ->
			{N, caught, doSomething}
	end.

demo5() ->
	try generate_exception(5)
	catch
		error:X ->
			{X, erlang:get_stacktrace()}
	end.

my_read_file(Filename) ->
	FullPath = filename:join(".", Filename),
	case file:read_file(FullPath) of
		{ok, Content} ->
			Content;
		{error, Reason} ->
			throw(Reason)
	end.
