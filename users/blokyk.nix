{ config, lib, pkgs, ... }:

let loq15_ahp9_key =
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOM7GQ43sqT5fVIkS7QvW3PcfPX9xJ6l6MY1IFSNFUhD blokyk";
in
{
  imports = [ <home-manager/nixos> ];

  users.users.blokyk = {
    isNormalUser = true;
    extraGroups = [ "blokyk" "sudo" "wheel" ];

    openssh.authorizedKeys.keys = [ loq15_ahp9_key ];
  };

  home-manager.users.blokyk = import ./blokyk/home.nix;

  # use system's nixpkgs instead of HM's one
  home-manager.useGlobalPkgs = true;
  # add packages to `users.users.blokyk.packages` instead of an HM-managed nix-profile
  home-manager.useUserPackages = true;

  # we have to enable nixos's zsh because otherwise nix will just refuse to change the shell (fair enough tbh)
  programs.zsh.enable = true;
  users.users.blokyk.shell = pkgs.zsh;
}
