{ pkgs, ... }: {
  services.hostrr.hosts = {
    ".".links = {
      "shrug" = {
        file = pkgs.writeText "shrug.txt" ''¯\_(ツ)_/¯'';
        content-type = "text/plain";
      };

      "brrr" = {
        file = "/var/www/brrr.opus";
        content-type = "audio/opus";
      };

      "zsotd".url = "https://www.youtube.com/playlist?list=PLW09UMpUBhV1Ab5BJR2On4e-K5q0VxjzG";
      "zsotd-thread".url = "https://hachyderm.io/@blokyk/115639654995706452";

      "proxy-tunnel".url = "https://github.com/blokyk/proxy-tunnel-pkg/releases/latest";

      "sxc-2024.pdf" = {
        content-type = "application/pdf";
        file = pkgs.buildTypstDocument {
          pname = "sxc-2024-report";
          version = "1.0";

          src = builtins.storePath <sxc-2024-report>;

          typstEnv = universe: [ universe.algo ];
          fonts = [ pkgs.libertinus ];
        };
      };

      "cv.pdf" = {
        content-type = "application/pdf";
        file = pkgs.buildTypstDocument {
          pname = "cv";
          version = "1.0";
          src = builtins.storePath <cv>;

          typstEnv = universe: [];
          fonts = [];
        };
      };

      "inject.nix".url = "https://raw.githubusercontent.com/blokyk/frozenpins/refs/heads/main/inject.nix";
    };
  };
}
