{ ... }: {
  nix = {
    settings.experimental-features = [ "nix-command" ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };

    optimise.automatic = true;
  };
}
