{ config, pkgs, ... }:
let
  suwayomi = config.services.suwayomi-server;
  passwdFile = config.sops.secrets.suwayomi.path;

  version = "2.1.2031";

  flare = config.services.flaresolverr;
in {
  services.suwayomi-server = {
    enable = true;
    openFirewall = false; # we already proxy through nginx

    package = pkgs.suwayomi-server.overrideAttrs (old: {
      version = version;
      # specifically fetch the jar artifact
      src = pkgs.fetchurl {
        url = "https://github.com/Suwayomi/Suwayomi-Server-Preview/releases/download/v${version}/Suwayomi-Server-v${version}.jar";
        hash = "sha256-NY+PqWv3BG4F7nFJrWc4/Nx2KXu2oKlTEx5h/1WLapY=";
      };
    });

    settings.server = {
      port = 7431;

      # Auth
      basicAuthEnabled = true;
      basicAuthUsername = "blokyk";
      basicAuthPasswordFile = passwdFile;

      # Downloader
      downloadAsCbz = true;
      localSourcePath = suwayomi.dataDir;

      # Library updates
      excludeUnreadChapters = false;
      excludeNotStarted = true;
      excludeCompleted = true;
      updateMangas = false;

      # Cloudflare bypass
      flareSolverrEnabled = flare.enable;
      flareSolverrUrl = "http://localhost:${toString flare.port}";

      # Extensions
      extensionRepos = [ "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json" ];
    };
  };

  sops.secrets.suwayomi = {
    sopsFile = ./suwayomi.secrets.yaml;
    owner = suwayomi.user;
    group = suwayomi.group;
  };
}
