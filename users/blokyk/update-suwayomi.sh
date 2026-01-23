#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ "${1:-}" = "" ]]; then
    echo "usage: update-suwayomi <version>"
    exit 1
fi

if [[ "$(git --git-dir=/etc/nixos/.git --work-tree=/etc/nixos status --porcelain=v1)" != "" ]]; then
    echo -e "\e[31m/etc/nixos was dirty, aborting\e[0m"
    exit 1
fi

version="$1"
tag="v$version"

new_jar_url="https://github.com/Suwayomi/Suwayomi-Server-Preview/releases/download/$tag/Suwayomi-Server-$tag.jar"
new_hash="$(nix --experimental-features nix-command hash to-sri "sha256:$(nix-prefetch-url "$new_jar_url")")"

sed -i 's/version = ".*"/version = "'"$version"'"/' /etc/nixos/services/suwayomi.nix
# we use '~' as the command delimiter instead of '/' because hashes can contain slashes
# cf: https://stackoverflow.com/questions/27787536/how-to-pass-a-variable-containing-slashes-to-sed
# (yes, i also could have done parameter subst, but eh at least i learned something new)
sed -i 's~hash = ".*"~hash = "'"$new_hash"'"~' /etc/nixos/services/suwayomi.nix

sudo nixos-rebuild switch --no-reexec

git --git-dir=/etc/nixos/.git --work-tree=/etc/nixos add /etc/nixos/services/suwayomi.nix
git --git-dir=/etc/nixos/.git --work-tree=/etc/nixos commit -m "suwayomi: update to v$version"