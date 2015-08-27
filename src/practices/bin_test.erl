%% API
-module(bin_test).
-export([reverse_bin/1, start/0, term_to_packet/1, packet_to_term/1, test/0, reverse_bit/2]).

%%%-------------------------------------------------------------------
%%% @author Shuieryin
%%% @copyright (C) 2015, Shuieryin
%%% @doc
%%%
%%% @end
%%% Created : 25. Apr 2015 10:21 AM
%%%-------------------------------------------------------------------
-author("Shuieryin").

start() ->
%% 	reverse_bin(<<"cat">>).
%% 	packet_to_term(term_to_packet("cat")).
	reverse_bit(<<1, 2, 3, 4, 5>>, <<>>).

test() ->
	"cat" = packet_to_term(term_to_packet("cat")),
	test_passed.

reverse_bin(Bin) when is_binary(Bin) ->
	%% the orders of endianess of little and big always differs
	Size = size(Bin) * 8,
	<<X:Size/integer-little>> = Bin,
	<<X:Size/integer-big>>.

term_to_packet(Term) ->
	Bin = term_to_binary(Term),
	Size = byte_size(Bin),
	<<1:4/integer-unit:8, Bin:Size/binary>>.

packet_to_term(<<_Header:4/integer-unit:8, Packet/binary>>) when is_binary(Packet) ->
	binary_to_term(Packet).

reverse_bit(<<>>, Acc) ->
	Acc;
reverse_bit(<<Head:1/binary, Rest/binary>>, Acc) ->
	reverse_bit(Rest, <<Head/binary, Acc/binary>>).