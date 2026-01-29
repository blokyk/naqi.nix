{ pkgs, ... }:
let
  buildTypstFromGitHub =
    { repo, name ? "${repo}.pdf", rev ? "main", hash, typstEnv ? (_: []), fonts ? [] }: {
      content-type = "application/pdf";
      file = pkgs.buildTypstDocument {
        inherit name typstEnv fonts;
        src = pkgs.fetchFromGitHub {
          owner = "blokyk";
          inherit repo rev hash;
        };
      };
    };
in {
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

      "proxy-tunnel".url = "https://github.com/blokyk/proxy-tunnel-pkg/releases/latest";

      "sxc-2024.pdf" = buildTypstFromGitHub {
        repo = "sxc-2024-report";
        rev = "pretty";
        hash = "sha256-gIkRh5XxjIbHM6Xi3KhSbSo973IAY8U/iwIbarkCiUo=";

        typstEnv = universe: [ universe.algo ];
        fonts = [ pkgs.libertinus ];
      };
    };
  };
}