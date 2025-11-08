{ options, ... }: {
  nix = {
    settings.experimental-features = [ "nix-command" ];

    # on a new system, you might need to run to do
    #   export NIX_PATH="$NIX_PATH:custom=/etc/nixos/modules"
    # before invoking `nixos-rebuild`
    nixPath = options.nix.nixPath.default ++ [
      "custom=/etc/nixos/modules"
    ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };

    optimise.automatic = true;
  };
}
