#!/bin/bash
REBAR_VER=3.11.1

cd config || exit
if [[ ! -f "./rebar3" ]]; then
    wget https://github.com/erlang/rebar3/releases/download/${REBAR_VER}/rebar3
    chmod +x rebar3
fi