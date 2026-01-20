#!/usr/bin/env bash

# Mostly a simple wrapper around `nixos-rebuild` to make it use
# the correct NIX_PATH (based on the pins in npins/source.json)
# instead of the ambient one. It also has ``
#
# This is particularly useful when bootstrapping this config,
# since that means you don't have to setup any channels or do
# any NIX_PATH shenanigans.
#
# However, at the end of the day, this is just a wrapper, so
# it can be used wherever `nixos-rebuild` would be used (i'm
# just too lazy to write a proper makeWrapper-based pkg)

set -o errexit

if [[ "$*" = 0 ]]; then
    echo "usage: "
    echo "  $0 <shell|env>        exec into a new shell with the correct environment"
    echo "  $0 <switch|test|...>  run nixos-rebuild with the given args"
    exit 1
fi

nixos_config="$(realpath "$(dirname "$0")")"

nix_path="$(nix eval --raw -f "$nixos_config/npins/mk-nix-path.nix")"

if [[ "$1" = "shell" ]] || [[ "$1" = "env" ]]; then
    exec \
        env NIX_PATH="nixos-config=$nixos_config/configuration.nix:$nix_path" \
            $SHELL
fi

env \
    NIX_PATH="nixos-config=$nixos_config/configuration.nix:$nix_path" \
    nixos-rebuild "$@"
