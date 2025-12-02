{ config, ... }:
let
  freshrss = config.services.freshrss;
  adminPass = config.sops.secrets.freshrss-admin;
in {
  services.freshrss = {
    enable = true;

    webserver = "nginx";
    virtualHost = "rss.zoeee.net";
    baseUrl = "https://rss.zoeee.net";

    defaultUser = "admin";
    passwordFile = adminPass.path;
    database.type = "sqlite";

    language = "en";
  };

  sops.secrets.freshrss-admin = {
    sopsFile = ./freshrss.secrets.yaml;
    owner = freshrss.user;
    group = freshrss.user;
  };

  # note: picoshare doesn't support not being at the root, so we can't
  # do `zoeee.net/sh` or something :/
  services.nginx.virtualHosts = {
    "rss.zoeee.net" = {
      forceSSL = true;
      enableACME = true;
    };
  };
}