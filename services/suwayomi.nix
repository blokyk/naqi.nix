{ config, lib, ... }:
let
  suwayomi = config.services.suwayomi-server;
  passwdFile = config.sops.secrets.suwayomi.path;
  syncyomi-api-key = config.sops.secrets.syncyomi-api-key.path;

  syncyomi-enabled = suwayomi.enable && (suwayomi.settings.server.syncYomiEnabled or false);

  flare = config.services.flaresolverr;
  syncyomi = config.services.syncyomi;
in {
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

      # SyncYomi
      syncYomiEnabled = syncyomi.enable;
      syncYomiHost = "http://127.0.0.1:${toString syncyomi.settings.port}"; # don't use reverse proxy to avoid request body limitations (and for perf)
      syncYomiApiKey = "$TACHIDESK_SYNCYOMI_API_KEY"; # substituted at runtime
      syncInterval = "600s"; # sync ten minutes

      # Library updates
      excludeUnreadChapters = false;
      excludeNotStarted = true;
      excludeCompleted = true;
      updateMangas = false;

      # Cloudflare bypass
      flareSolverrEnabled = flare.enable;
      flareSolverrUrl = "http://localhost:${toString flare.port}";

      # databaseType = "POSTGRESQL";
      # databaseUrl  = "";

      # Extensions
      extensionRepos = [ "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json" ];
    };
  };

  systemd.services.suwayomi-server = {
    script = lib.mkBefore ''
      # ensure data dir exists (important for envsubst for some reason)
      mkdir -p ${suwayomi.dataDir}/.local/share/Tachidesk

      ${lib.optionalString syncyomi-enabled ''
        export TACHIDESK_SYNCYOMI_API_KEY="$(<${syncyomi-api-key})"
      ''}
    '';
  };

  sops.secrets.suwayomi = lib.mkIf suwayomi.enable {
    sopsFile = ./suwayomi.secrets.yaml;
    owner = suwayomi.user;
    group = suwayomi.group;
  };

  sops.secrets.syncyomi-api-key = lib.mkIf syncyomi-enabled {
    sopsFile = ./suwayomi.secrets.yaml;
    owner = suwayomi.user;
    group = suwayomi.group;
  };
}
