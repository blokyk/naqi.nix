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

      "zsotd".url = "https://www.youtube.com/playlist?list=PLW09UMpUBhV1Ab5BJR2On4e-K5q0VxjzG";
      "zsotd-thread".url = "https://hachyderm.io/@blokyk/115639654995706452";

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