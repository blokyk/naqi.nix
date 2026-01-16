#!/usr/bin/env bash

# A simple wrapper around `nixos-rebuild` to make it use the
# correct NIX_PATH (based on the pins in npins/source.json)
# instead of the ambient one.
#
# This is particularly useful when bootstrapping this config,
# since that means you don't have to setup any channels or do
# any NIX_PATH shenanigans.
#
# However, at the end of the day, this is just a wrapper, so
# it can be used wherever `nixos-rebuild` would be used (i'm
# just too lazy to write a proper makeWrapper-based pkg)

set -o errexit

# make sure we're in /etc/nixos
cd "$(dirname "$0")"

nix_path="$(nix eval --raw -f npins/mk-nix-path.nix)"

env \
    NIX_PATH="nixos-config=$PWD/configuration.nix:$nix_path" \
    nixos-rebuild "$@"
