-module(p_erlang_sup).

-behaviour(supervisor).

%% API
-export([start/0,
    start_link/0,
    start_in_shell_for_testing/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start() ->
    spawn(
        fun() ->
            supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = [])
        end
    ).

start_in_shell_for_testing() ->
    {ok, Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = []),
    unlink(Pid).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    %% Install my personal error handler
    gen_event:swap_handler(alarm_handler, {alarm_handler, swap}, {my_alarm_handler, xyz}),
    {ok, {
        {one_for_one, 3, 10},
        [
            {tag1,
                {area_server, start_link, []},
                permanent,
                10000,
                worker,
                [area_server]
            },
            {tag2,
                {prime_server, start_link, []},
                permanent,
                10000,
                worker,
                [prime_server]
            }
        ]
    }}.
