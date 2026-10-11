let
  injector = import ./npins/inject.nix (pins: {
    nixos-config.outPath = ./configuration2.nix;
  });

  # fixme: this (currently) discards info about the project-ness of <nixpks/nixos>
  nixos-path = injector.pins.nixpkgs + "/nixos";
in
  injector.import nixos-path {
    configuration = ./configuration2.nix;
  }
