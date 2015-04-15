%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Apr 2015 8:40 PM
%%%-------------------------------------------------------------------
-module(main).
-author("Li").

%% API
-import(mylists2, [pmap/2]).
-import(lib_misc1, [pmap1/2]).
-export([start/0]).

start() ->
	L = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21],
	CusFunc = fun(_) ->
		make_many_ref(20, [])
	end,
	Result = mylists2:pmap(CusFunc, L),
%% 	Result = lib_misc1:pmap1(CusFunc, L),
	erlang:display(Result).

make_many_ref(0, RefList) ->
	RefList;
make_many_ref(Times, RefList) ->
	make_many_ref(Times - 1, [erlang:make_ref() | RefList]).
