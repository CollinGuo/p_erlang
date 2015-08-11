-module(lib_primes).
%% API
-export([make_prime/1,
    is_prime/1,
    make_random_int/1]).

%%%-------------------------------------------------------------------
%%% @author Li
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Aug 2015 9:59 PM
%%%-------------------------------------------------------------------
-author("Li").

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% make a prime
%%
%% @end
%%--------------------------------------------------------------------
make_prime(1) ->
    lists:nth(random:uniform(4), [2, 3, 5, 7]);
make_prime(K) when K > 0 ->
    N = make_random_int(K),
    if
        N > 3 ->
            io:format("Generating a ~w digit prime", [K]),
            MaxTries = N - 3,
            P1 = make_prime(MaxTries, N + 1),
            io:format("~n"),
            P1;
        true ->
            make_prime(K)
    end.

%%--------------------------------------------------------------------
%% @doc
%% is a prime
%%
%% @end
%%--------------------------------------------------------------------
is_prime(D) when D < 10 ->
    lists:member(D, [2, 3, 5, 7]);
is_prime(D) ->
    new_seed(),
    is_prime(D, 100).

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% make prime
%%
%% @end
%%--------------------------------------------------------------------
make_prime(0, _) ->
    exit(impossible);
make_prime(K, P) ->
    io:format("."),
    case is_prime(P) of
        true ->
            P;
        false ->
            make_prime(K - 1, P + 1)
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% is prime
%%
%% @end
%%--------------------------------------------------------------------
is_prime(D, Ntests) ->
    N = length(integer_to_list(D)) - 1,
    is_prime(Ntests, D, N).

is_prime(0, _, _) ->
    true;
is_prime(Ntests, N, Len) ->
    K = random:uniform(Len),
    A = make_random_int(K),
    if
        A < N ->
            case lib_lin:pow(A, N, N) of
                A ->
                    is_prime(Ntests - 1, N, Len);
                _ ->
                    false
            end;
        true ->
            is_prime(Ntests, N, Len)
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% a random integer with N digits.
%%
%% @end
%%--------------------------------------------------------------------
make_random_int(N) ->
    new_seed(),
    make_random_int(N, 0).

make_random_int(0, D) ->
    D;
make_random_int(N, D) ->
    make_random_int(N - 1, D * 10 + (random:uniform(10) - 1)).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% new seed
%%
%% @end
%%--------------------------------------------------------------------
new_seed() ->
    {_, _, X} = erlang:now(),
    {H, M, S} = time(),
    H1 = H * X rem 32767,
    M1 = M * X rem 32767,
    S1 = S * X rem 32767,
    put(random_seed, {H1, M1, S1}).