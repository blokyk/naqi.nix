{ config, ... }:
let
  suwayomi = config.services.suwayomi-server;
  passwdFile = config.sops.secrets.suwayomi.path;
in {
  services.suwayomi-server = {
    enable = true;
    openFirewall = false; # we already proxy through nginx

    settings.server = {
      port = 7431;
      basicAuthEnabled = true;
      basicAuthUsername = "blokyk";
      basicAuthPasswordFile = passwdFile;
      extensionRepos = [ "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json" ];
    };
  };

  sops.secrets.suwayomi = {
    sopsFile = ./suwayomi.secrets.yaml;
    owner = suwayomi.user;
    group = suwayomi.group;
  };

  services.nginx.virtualHosts."manga.zoeee.net" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString suwayomi.settings.server.port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
