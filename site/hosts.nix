{ config, ... }: {
  services.hostrr = {
    enable = true;
    base = "zoeee.net";

    hosts = {
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
    };
  };
}