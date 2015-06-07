%% API
-module(try_test).
-export([matcher_test/2, generate_exception/1, demo1/0, demo2/0, sqrt/1, demo3/0, demo4/0, demo5/0, my_read_file/1, module_size_test/0, module_size_tc/0]).

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

-type tag() :: {tag, integer()}.
-spec matcher_test([Tag | Tail], Result) ->
	list() when
	Tag :: tag(),
	Tail :: list(),
	Result :: list().

matcher_test([], Result) ->
	Result;
matcher_test([Header | Tail], Result) ->
	case Header of
		{tag, Number} ->
			matcher_test(Tail, [Number | Result]);
		_ ->
			erlang:display({badarg, Header}),
			matcher_test(Tail, Result)
	end.

module_size_test() ->
	%% TODO -> go back and rewrite chapter 8 exercise 2 after erl 18.0 is released.
	module_most_count(code:all_loaded(), {noModule, 0}, #{}).

test_func_tc(0, Acctime) ->
	Acctime;
test_func_tc(Times, AccTime) ->
	{CurTime, _} = timer:tc(try_test, module_size_test, []),
	test_func_tc(Times - 1, AccTime + CurTime).

module_size_tc() ->
	Times = 10000,
	test_func_tc(Times, 0) div Times.

%% module_size([{exports, ExportModuleList} | _]) ->
%% 	length(ExportModuleList).

module_function_count([], FuncCount, FuncNamesMap) ->
	[{funcCount, FuncCount}, {funcNamesMap, FuncNamesMap}];
module_function_count([{FunctionName, _} | Tail], FuncCount, FuncNamesMap) ->
	case maps:is_key(FunctionName, FuncNamesMap) of
		true ->
			CurCount = maps:get(FunctionName, FuncNamesMap),
%% 			#{FunctionName := CurCount} = FuncNamesMap,
			NewFuncNamesMap = maps:put(FunctionName, CurCount + 1, FuncNamesMap);
		false ->
			NewFuncNamesMap = maps:put(FunctionName, 1, FuncNamesMap)
%% 			NewFuncNamesMap = FuncNamesMap#{FunctionName => 1}
	end,
	module_function_count(Tail, FuncCount + 1, NewFuncNamesMap).

module_most_count([], MaxFuncNameResult, FuncNamesMap) ->
%% 	The commented method is slightly faster(about 0.3 milli seconds) than using maps:get/3,
%% 	it is recommanded using maps:get/3 becaues of the codes of elegant and theorectically has less bug.
%% 	Fun = fun(K, V, CurMaxFuncName) ->
%% 		case CurMaxFuncName of
%% 			startCheckFuncName ->
%% 				K;
%% 			_ ->
%% 				CurMaxFuncCount = maps:get(CurMaxFuncName, FuncNamesMap),
%% 				case V > CurMaxFuncCount of
%% 					true ->
%% 						K;
%% 					false ->
%% 						CurMaxFuncName
%% 				end
%% 		end
%% 	end,
	Fun = fun(K, V, CurMaxFuncName) ->
		CurMaxFuncCount = maps:get(CurMaxFuncName, FuncNamesMap, 0),
		case V > CurMaxFuncCount of
			true ->
				K;
			_ ->
				CurMaxFuncName
		end
	end,
	MaxFuncNameUsed = maps:fold(Fun, startCheckFuncName, FuncNamesMap),
	erlang:display(FuncNamesMap),
	[MaxFuncNameResult, {MaxFuncNameUsed, maps:get(MaxFuncNameUsed, FuncNamesMap)}];
module_most_count([{ModuleName, _} | Tail], {OldModuleName, OldCount}, FuncNamesMap) ->
	% when module name is a varaiable, using apply/3 is slightly(0.5 milli seconds) faster than ModuleName:some_funcion.
	[{funcCount, CurCount}, {funcNamesMap, UpdatedFuncNamesMap}] = module_function_count(apply(ModuleName, module_info, [exports]), 0, FuncNamesMap),
	case CurCount > OldCount of
		true ->
			FinalMaxModuleName = ModuleName,
			FinalCount = CurCount;
		false ->
			FinalMaxModuleName = OldModuleName,
			FinalCount = OldCount
	end,
	module_most_count(Tail, {FinalMaxModuleName, FinalCount}, UpdatedFuncNamesMap).
