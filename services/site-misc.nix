# a few resources i want to serve with a short link for misc reasons

{ pkgs, ... }:
let
  sxc-gh = pkgs.fetchFromGitHub {
    owner = "blokyk";
    repo = "sxc-2024-report";
    rev = "pretty";
    hash = "sha256-gIkRh5XxjIbHM6Xi3KhSbSo973IAY8U/iwIbarkCiUo=";
  };

  sxc = pkgs.buildTypstDocument {
    name = "sxc-2024.pdf";
    src = sxc-gh;
    typstEnv = universe: [ universe.algo ];
    fonts = [
      pkgs.libertinus
    ];
  };
in {
  services.nginx.virtualHosts."zoeee.net" = {
    locations."/shrug" = {
      return = ''
        200 '¯\_(ツ)_/¯'
      '';
      extraConfig = ''
        default_type text/plain;
        charset utf-8;
      '';
    };

    locations."=/brrr" = {
      alias = "/var/www/brrr.opus";
      extraConfig = ''
        default_type audio/ogg;
        try_files ''$uri =404;
      '';
    };

    locations."=/sxc-2024.pdf" = {
      alias = sxc;
      extraConfig = ''
        default_type application/pdf;
        try_files ''$uri =404;
      '';
    };

    # redirect `zoeee.net/feeds` to a folder containing OPML files,
    # so that freshrss can use it as a "dynamic OPML" source
    # (also known as dollar-store-dynamic-OPML)
    locations."/feeds/" = {
      alias = "/var/www/zoeee.net/feeds/";
    };
  };
}
