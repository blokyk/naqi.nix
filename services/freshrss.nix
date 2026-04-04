{ config, lib, ... }:
let
  freshrss = config.services.freshrss;
  adminPass = config.sops.secrets.freshrss-admin;
  host = "rss.${config.services.hostrr.base}";
in {
  services.freshrss = {
    enable = true;

    webserver = "nginx";
    virtualHost = host;
    baseUrl = "https://${host}";

    defaultUser = "admin";
    passwordFile = adminPass.path;
    database.type = "sqlite";

    language = "en";
  };

  sops.secrets.freshrss-admin = lib.mkIf freshrss.enable {
    sopsFile = ./freshrss.secrets.yaml;
    owner = freshrss.user;
    group = freshrss.user;
  };
}
