{ config, ... }: {
  services.immich = {
    enable = true;

    host = "127.0.0.1"; # allow any host
    port = 2283;

    openFirewall = false; # we already proxy through nginx
    database.enableVectors = false; # don't enable pgvecto-rs
  };
}
