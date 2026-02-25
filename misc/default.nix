{ ... }: {
  imports = [
    ./nano.nix
    ./nix-output-monitor.nix
    ./overlays.nix
    ./sops.nix
  ];
}
