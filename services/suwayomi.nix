{ config, lib, pkgs, ... }:

let
  port = 7431;
in
{
  services.suwayomi-server = {
    enable = true;
    openFirewall = false; # we already proxy through nginx

    settings.server = {
      port = port;
      basicAuthEnabled = true;
      basicAuthUsername = "blokyk";
      basicAuthPasswordFile = "/var/secrets/suwayomi-server/passwd"; # ! MUST BE A STRING! OTHERWISE PASSWORD WILL BE IN NIX STORE
      extensionRepos = [ "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json" ];
    };
  };

  services.nginx.virtualHosts."manga.zoeee.net" = {
    #enableACME = true;
    forceSSL = false; # fixme: setup ssl
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
