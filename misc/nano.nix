{ pkgs, lib, ... }: {
  programs.nano.nanorc = ''
    include "${pkgs.nanorc}/share/*.nanorc"

    ${builtins.readFile ./nanorc}
    '';
}