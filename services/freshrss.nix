{ config, lib, ... }:
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

  sops.secrets.freshrss-admin = lib.mkIf freshrss.enable {
    sopsFile = ./freshrss.secrets.yaml;
    owner = freshrss.user;
    group = freshrss.user;
  };

  # we can't define it with hostrr becauses freshrss uses complex rewriting
  # rules and fastcgi in its nginx configuration
  services.nginx.virtualHosts = {
    "rss.zoeee.net" = {
      forceSSL = true;
      enableACME = true;
    };
  };
}