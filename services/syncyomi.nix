{ config, lib, ... }:
let
  syncyomi-cfg = config.services.syncyomi;
  session-secret = config.sops.secrets.syncyomi;
in {
  imports = [ (import <zoeee/modules>) ];

  services.syncyomi = {
    enable = true;

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
