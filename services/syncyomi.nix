{ config, lib, pkgs, ... }:
let
  syncyomi-pkg = pkgs.syncyomi.overrideAttrs (prev: {
    version = "1.1.4";
    src = pkgs.fetchFromGitHub {
      owner = "syncyomi";
      repo = "syncyomi";
      tag = "v1.1.4";
      hash = "sha256-pU3zxzixKoYnJsGpfvC/SVWIu0adsaiiVcLn0IZe64w=";
    };
    vendorHash = "sha256-fzPEljXFskr1/qzTsnASFNNc+8vA7kqO21mhMqwT44w=";

    # todo: fix version patch
    # todo(real): upstream update + finalAttrs-based patch to nixpkgs
  });

  syncyomi-cfg = config.services.syncyomi;
  session-secret = config.sops.secrets.syncyomi;
in {
  imports = [ <zoeee/modules> ];

  services.syncyomi = {
    enable = true;
    package = syncyomi-pkg;

    settings = {
      host = "0.0.0.0";
      port = 8282;
      baseUrl = "/";

      logLevel = "WARN";

      sessionSecretFile = session-secret.path;
    };
  };

  sops.secrets.syncyomi = lib.mkIf syncyomi-cfg.enable {
    sopsFile = ./syncyomi.secrets.yaml;
    owner = syncyomi-cfg.user;
    group = syncyomi-cfg.group;
  };
}