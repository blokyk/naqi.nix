{ config, ... }:
let
  port = 7431;
  passwdFile = config.sops.secrets.suwayomi.path;
in {
  services.suwayomi-server = {
    enable = true;
    openFirewall = false; # we already proxy through nginx

    settings.server = {
      port = port;
      basicAuthEnabled = true;
      basicAuthUsername = "blokyk";
      basicAuthPasswordFile = passwdFile;
      extensionRepos = [ "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json" ];
    };
  };

  services.nginx.virtualHosts."manga.zoeee.net" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
