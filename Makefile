all: install br

install:
	@./config/install.sh

reset:
	@git fetch --all
	@git reset --hard origin/master

ct:
	@./config/rebar3 ct
	@rm -f test/*.beam

br: build run

build:
	@./config/rebar3 compile
	@./config/rebar3 release

run:
	@./_build/default/rel/p_erlang/bin/p_erlang console