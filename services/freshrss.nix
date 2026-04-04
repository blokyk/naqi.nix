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

  # we can't define it with hostrr becauses freshrss uses complex rewriting
  # rules and fastcgi in its nginx configuration
  services.nginx.virtualHosts = {
    ${host} = {
      forceSSL = true;
      enableACME = true;
    };
  };
}
