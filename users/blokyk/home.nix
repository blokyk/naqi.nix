let
  aliases = import ./aliases.nix;
in
{ config, lib, pkgs, xdg, ... }: {
  imports = [ <custom/zsh-powerlevel10k> ];

  home.stateVersion = "25.05"; # this should stay at the version originally installed

  home.packages = with pkgs; [
    nix-output-monitor
    systemctl-tui
    gitstatus
    fd
    ripgrep
  ];

  home.sessionVariables.NIXD_FLAGS = "-log=error";

  programs.zsh = {
    enable = true;
    dotDir = config.xdg.configHome + "/zsh";

    # todo: migrate to z4h
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };

    shellAliases = aliases;
  };

  programs.zsh-powerlevel10k = {
   enable = true;
   theme = config.programs.zsh-powerlevel10k.themes.robbyrussell // {
     mode = "compatible";
   };
  };

  # use nix-index for the command-not-found utility, which gives a list of pkgs
  # that could provide the given command
  # programs.nix-index.enable = true; # disabled bc it's too slow (and you can't ctrl-c it)
}
