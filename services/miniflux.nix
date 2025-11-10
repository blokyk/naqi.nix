{ ... }:
let
  port = 3550;
in {
  # a minimalist rss reader/aggregator
  services.miniflux = {
    enable = true;
    adminCredentialsFile = "/var/secrets/miniflux.pass";
    config = {
      PORT = port;
      BASE_URL = "https://rss.zoeee.net/";
    };
  };

  services.nginx.virtualHosts."rss.zoeee.net" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}