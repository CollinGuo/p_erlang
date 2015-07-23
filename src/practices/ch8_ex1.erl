-module(ch8_ex1).
-export([
	test/0,
	functions_count/1,
	functions_names/1
]).

% Reread the section about Mod:module_info() in this chapter.
% Give the command dict:module_info().
% How many functions does this module return?

test() ->
	Size = functions_count(lists:module_info(exports)),
	true = Size > 30,

	done.

functions_count([]) -> 0;
functions_count(T) ->
	Functions = functions_names(T),
	length(lists:usort(Functions)).

functions_names(T) ->
	lists:map(fun({F, _A}) -> F end,  T).