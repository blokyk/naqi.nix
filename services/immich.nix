{ config, lib, pkgs, ... }:

{
  services.immich = {
    enable = true;

    host = "127.0.0.1"; # allow any host
    port = 2283;

    database.enableVectors = false; # don't enable pgvecto-rs
  };

  # setup immich on the img.zoeee.net subdomain
  services.nginx.virtualHosts."img.zoeee.net" = {
    #enableACME = true;
    forceSSL = false; # fixme: setup ssl
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.immich.port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      extraConfig = ''
        client_max_body_size 50000M;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        send_timeout 600s;
      '';
    };
  };
}
