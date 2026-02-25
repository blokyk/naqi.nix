# if we're using lix, then we need to use an older version of nix-output-monitor,
# because cppnix changed its internal-json format and nom had to upgrade, but lix
# chose not to change it

{ config, lib, ... }:
let
  isLix = lib.hasPrefix "lix" config.nix.package.name;
in {
  # we can't use a `mkIf` based on the config because it causes infinite recursion
  nixpkgs.overlays = [
    (final: prev: {
      # we need to use an older version of nix-output-monitor, because
      # since 2.1.7 it adapts to cppnix's slightly breaking json format,
      # which lix doesn't use
      nix-output-monitor = if (isLix) then prev.nix-output-monitor.overrideAttrs {
        version = "2.1.6";
        src = prev.fetchzip {
          url = "https://code.maralorn.de/maralorn/nix-output-monitor/archive/v2.1.6.tar.gz";
          sha256 = "sha256-YfxFcGD9U7RzctnTRUQX1Nsz2EtiDIUGpz2nTo0OSWw=";
        };
      } else prev.nix-output-monitor;
    })
  ];
}
