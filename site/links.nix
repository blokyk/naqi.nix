{ pkgs, ... }: {
  services.hostrr.hosts = {
    ".".links = {
      "shrug" = {
        file = pkgs.writeText "shrug.txt" ''¯\_(ツ)_/¯'';
        content-type = "text/plain";
      };

      "brrr" = {
        file = /var/www/brrr.opus;
        content-type = "audio/opus";
      };

      "sxc-2024.pdf" = let
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
        file = sxc;
        content-type = "application/pdf";
      };
    };
  };
}