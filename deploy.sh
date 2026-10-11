nom-shell -p lixPackageSets.stable.nixos-rebuild-ng --command 'nixos-rebuild switch --no-reexec --use-substitutes --target-host=root@naqi -f . --log-format internal-json -v |& nom --json'
