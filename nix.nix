{ lib, pkgs, ... }: {
  nix = {
    # use Lix as main nix impl instead of CppNix
    package = pkgs.lixPackageSets.stable.lix;

    settings = {
      experimental-features = [ "flakes" "nix-command" ];

      # disabled because I'm not updating <zoeee> constantly anymore
      # # ensures that tarballs always get re-fetched when appropriate
      # tarball-ttl = 0;
    };

    # set up NIX_PATH to point to the pinned versions from npins
    nixPath =
      let pinnedPaths =
            lib.splitString ":"
              (import ./npins/mk-nix-path.nix);
      in
        [ "nixos-config=/etc/nixos/configuration.nix" ] ++ pinnedPaths;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };

    optimise.automatic = true;
  };

  # this is used to make sure that `nix-shell -p foo` and `nix run #foo` and all
  # other uses of <nixpkgs> reference the same instance: the one pinned by `npins`
  #
  # cf https://jade.fyi/blog/pinning-nixos-with-npins#killing-channels
  nixpkgs.flake.source = (import ./npins).nixpkgs;
}
