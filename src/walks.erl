%% API
-module(walks).
-export([plan_route/2, plan_rounte1/2]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Apr 2015 2:42 PM
%%%-------------------------------------------------------------------
-author("Li").

-spec plan_route(From :: point(), To :: point()) ->
	route().

-type direction() :: north | south | east | west.
-type point() :: {integer(), integer()}.
-type route() :: [{go, direction(), integer()}].

plan_route({X1, Y1}, {X2, Y2}) ->
	[{X1, Y1}, {X2, Y2}].

-spec plan_rounte1(From :: position(), To :: position()) ->
	[].

-type angle() :: {Degrees :: 0..360, Minutes :: 0..60, Seconds :: 0..60}.
-type position() :: {latitude | longtidue, angle()}.

plan_rounte1(_, _) ->
	a.
