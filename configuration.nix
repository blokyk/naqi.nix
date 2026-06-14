let
  injector = import ./npins/inject.nix (pins: {
    nixos-config.outPath = ./configuration.nix;
    # todo: add your overrides/follows here!
  });

  # fixme: this (currently) discards info about the project-ness of <nixpks/nixos>
  nixos-path = injector.pins.nixpkgs + "/nixos";

  config = injector.import nixos-path {
    configuration = ./configuration2.nix;
  };
in {
  system.build = {
    _type = "override";
    priority = 0;
    content = config.config.system.build; /*{
      inherit (config.config.system.build)
        images           # build-image
        vm               # build-vm
        vmWithBooLoader  # build-vm-with-bootloader
        toplevel         # switch, boot
        nixos-rebuild    # used in case --no-reexec/--fast is not specified
        ;
    };*/
  };
}
