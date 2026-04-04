{ config, ... }: {
  services.hostrr = {
    enable = true;
    base = config.networking.domain;

    hosts = {
      # we can't actually define it with hostrr becauses freshrss uses
      # complex rewriting rules and fastcgi in its nginx configuration.
      # note: this has to be kept in sync with the host in services/freshrss.nix
      "rss" = {
        extraConfig = {
          forceSSL = true;
          enableACME = true;
        };
      };

      "img" = {
        port = config.services.immich.port;
        maxUpload = "50000m";
        timeout = 600;
      };

      "sh" = {
        port = config.services.picoshare.port;
        maxUpload = "10000m";
        timeout = 600;
      };

      "manga".port = config.services.suwayomi-server.settings.server.port;

      "sync" = {
        port = config.services.syncyomi.settings.port;
        maxUpload = "1000m";
        timeout = 600;
      };
    };
  };
}
