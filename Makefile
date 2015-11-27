all: install

install:
	@./config/install.sh

run:
	@./config/run.sh

reset:
	@git fetch --all
	@git reset --hard origin/master

ct:
	@rebar3 ct
	@rm -f test/*.beam