-module(ch8_ex2).
-include("ch8_ex2.hrl").
-export([test/0]).

% The command code:all_loaded() returns a list of {Mod,File} pairs of all modules
% that have been loaded into the Erlang system.
% Use the BIF Mod:module_info() to find out about these modules.
% Write functions to determine which module exports the most functions and which function name is the most common.
% Write a function to find all unambiguous function names, that is, function names that are used in only one module.

test() ->
	Modules = lists:map(fun({Name, _}) -> Name end, code:all_loaded()),
	Modules_info = lists:map(fun collect_module_info/1, Modules),
	M1 = module_max_exports(Modules_info),

	io:format("module = ~w, functions count = ~w~n", [M1#module.name, M1#module.functions_count]),
	done.

collect_module_info(Module) ->
	Exports = Module:module_info(exports),
	N = ch8_ex1:functions_names(Exports),
	C = ch8_ex1:functions_count(Exports),
	#module{name = Module, functions_names = N, functions_count = C}.

module_max_exports(Modules) when is_list(Modules) ->
	[H | T] = Modules,

	Module = lists:foldl(fun(M, Acc) ->
		case M#module.functions_count > Acc#module.functions_count of
			true -> M;
			false -> Acc
		end
	end, H, T),

	Module.