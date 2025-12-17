{ ... }: {
  services.immich = {
    enable = true;

    host = "0.0.0.0"; # allow any host
    port = 2283;

    openFirewall = false; # we already proxy through nginx
    database.enableVectors = false; # don't enable pgvecto-rs
  };
}
