%% API
-module(math_functions).
-export([even/1, odd/1, filter/2, split1/3, split2/1]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 15. Apr 2015 1:20 PM
%%%-------------------------------------------------------------------
-author("Shuieryin").

even(Number) ->
	is_number_even(Number).

odd(Number) ->
	is_number_even(Number) xor true.

is_number_even(Number) ->
	case Number rem 2 of
		1 ->
			false;
		0 ->
			true
	end.

filter(Func, List) ->
	[Element || Element <- List, Func(Element)].

split1([], OddList, EvenList) ->
	{lists:reverse(OddList), lists:reverse(EvenList)};
split1([Head | Tail], OddList, EvenList) ->
	case Head rem 2 of
		1 ->
			split1(Tail, [Head | OddList], EvenList);
		0 ->
			split1(Tail, OddList, [Head | EvenList])
	end.

split2(List) ->
	{filter(fun(X) -> X rem 2 =:= 1 end, List), filter(fun(X) -> X rem 2 =:= 0 end, List)}.
