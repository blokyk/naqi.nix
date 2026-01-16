{ pkgs, ... }: {
  nix = {
    # use Lix as main nix impl instead of CppNix
    package = pkgs.lixPackageSets.stable.lix;

    settings = {
      experimental-features = [ "nix-command" ];

      # disabled because I'm not updating <zoeee> constantly anymore
      # # ensures that tarballs always get re-fetched when appropriate
      # tarball-ttl = 0;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };

    optimise.automatic = true;
  };
}
