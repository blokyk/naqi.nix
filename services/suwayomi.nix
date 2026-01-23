{ config, lib, pkgs, ... }:
let
  suwayomi = config.services.suwayomi-server;
  passwdFile = config.sops.secrets.suwayomi.path;

  flare = config.services.flaresolverr;
in {
  nixpkgs.overlays = [(
    final: prev: {
      suwayomi-server = prev.suwayomi-server.overrideAttrs (old: rec {
        version = "2.1.2060";

        # specifically fetch the jar artifact
        src = pkgs.fetchurl {
          url = "https://github.com/Suwayomi/Suwayomi-Server-Preview/releases/download/v${version}/Suwayomi-Server-v${version}.jar";
          hash = "sha256-AMwXScDrFzBcf/Q8rsJpQw/7PhTmv75ZS3d8SI7R2es=";
        };
      });
    }
  )];

  services.suwayomi-server = {
    enable = true;
    openFirewall = false; # we already proxy through nginx

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

  sops.secrets.suwayomi = lib.mkIf suwayomi.enable {
    sopsFile = ./suwayomi.secrets.yaml;
    owner = suwayomi.user;
    group = suwayomi.group;
  };
}
