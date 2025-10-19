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

  # bash is managed by the nixos, not home-manager, so use nixos's module to manage its options
  programs.bash.shellAliases =  import ./blokyk/aliases.nix;
}
