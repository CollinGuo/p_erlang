%% @author Administrator
%% @doc @todo Add description to shop.


-module(shop).

%% ====================================================================
%% API functions
%% ====================================================================
-import(lists, [sum/1, map/2]).
-export([total/1, cost/1, total1/1, start/0, total2/2, total2/1, total3/1]).


%% ====================================================================
%% Internal functions
%% ====================================================================
%% shop:total([{pears,6},{milk,3}]).


total([{What, N} | T]) ->
	shop:cost(What) * N + total(T);
total([]) ->
	0.

cost(oranges) ->
	5;
cost(newspaper) ->
	8;
cost(apples) ->
	2;
cost(pears) ->
	9;
cost(milk) ->
	7.

total1(L) ->
	sum(
		map(
			fun({What, N}) ->
				shop:cost(What) * N end,
			L
		)
	).

start() ->
	BuyList = [{oranges, 4}, {newspaper, 1}, {apples, 10}, {pears, 6}, {milk, 3}],
	total2(0, BuyList).
%% 	total2(BuyList).
%% 	total3(BuyList).

%% tail recursion
total2(Total, []) ->
	Total;
total2(Total, [{ItemName, Cost} | TailBuyList]) ->
	total2(Total + shop:cost(ItemName) * Cost, TailBuyList).

total2(BuyList) ->
	CalcFunc = fun({ItemName, Cost}) ->
		shop:cost(ItemName) * Cost
	end,
	sum(map(CalcFunc, BuyList)).

%% List comprehensions
total3(BuyList) ->
	sum([shop:cost(Name) * Count || {Name, Count} <- BuyList]).

%% Steps:
%% [{oranges,4},{newspaper,1},{apples,10},{pears,6},{milk,3}]
%% {oranges, 4}|[{newspaper,1},{apples,10},{pears,6},{milk,3}]
%% shop:cost(oranges) * 4 + total([{newspaper,1},{apples,10},{pears,6},{milk,3}])
%% 5 * 4 + total([{newspaper,1},{apples,10},{pears,6},{milk,3}])
%% 20 + total([{newspaper,1},{apples,10},{pears,6},{milk,3}])
%% {newspaper,1}|[{apples,10},{pears,6},{milk,3}]
%% 20 + shop:cost(newspaper) * 1 + total([{apples,10},{pears,6},{milk,3}])
%% 20 + 8 * 1 + total([{apples,10},{pears,6},{milk,3}])
%% 20 + 8 + total([{apples,10},{pears,6},{milk,3}])
%% {apples,10}|[{pears,6},{milk,3}])
%% 20 + 8 + shop:cost(apples) * 10 + total([{pears,6},{milk,3}])
%% 20 + 8 + 2 * 10 + total([{pears,6},{milk,3}])
%% 20 + 8 + 20 + total([{pears,6},{milk,3}])
%% {pears,6}|[{milk,3}]
%% 20 + 8 + 20 + shop:cost(pears) * 6 + total([{milk,3}])
%% 20 + 8 + 20 + 9 * 6 + total([{milk,3}])
%% 20 + 8 + 20 + 54 + total([{milk,3}])
%% {milk,3}|[]
%% 20 + 8 + 20 + 54 + shop:cost(milk) * 3 + total([])
%% 20 + 8 + 20 + 54 + 7 * 3 + total([])
%% 20 + 8 + 20 + 54 + 21 + total([])
%% 20 + 8 + 20 + 54 + 21 + 0
%% 20 + 8 + 20 + 54 + 21
%% 20 + 8 + 20 + 75
%% 20 + 8 + 95
%% 20 + 103
%% 123
