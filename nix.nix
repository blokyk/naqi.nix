{ pkgs, ... }: {
  nix = {
    # use Lix as main nix impl instead of CppNix
    package = pkgs.lixPackageSets.stable.lix;

    settings = {
      experimental-features = [ "nix-command" ];

      # ensures that tarballs always get re-fetched when appropriate
      tarball-ttl = 0;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };

    optimise.automatic = true;
  };
}
