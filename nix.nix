{ lib, pkgs, ... }: {
  nix = {
    # use Lix as main nix impl instead of CppNix
    package = pkgs.lixPackageSets.stable.lix;

    settings = {
      experimental-features = [ "flakes" "nix-command" ];

      trusted-users = [ "root" "blokyk" ];

      # setup signing key so this can be used as a substituter
      secret-key-files = "/root/nix/cache-priv-key.pem";

      min-free = 1 * 1024 * 1024 * 1024; # 1GiB
      max-free = 8 * 1024 * 1024 * 1024; # 8GiB
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
