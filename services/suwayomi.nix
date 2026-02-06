{ config, lib, ... }:
let
  suwayomi = config.services.suwayomi-server;
  passwdFile = config.sops.secrets.suwayomi.path;
  syncyomi-api-key = config.sops.secrets.syncyomi-api-key.path;

  flare = config.services.flaresolverr;
  syncyomi = config.services.syncyomi;
in {
  nixpkgs.overlays = [(
    final: prev: {
      suwayomi-server-unwrapped = (prev.callPackage <zoeee/pkgs> {}).suwayomi-server-unwrapped.overrideAttrs (
        finalAttrs: _: {
          version = "2.1.2038";
          rev = "b97a808e7bb09e3faade22f76dbe60f2babebade";

          # specifically fetch the jar artifact
          src = prev.fetchFromGitHub {
            owner = "Suwayomi";
            repo = "Suwayomi-Server";
            rev = finalAttrs.rev;
            hash = "sha256-v1tjNda7PzwllT4jvotIYcQ4d/vpjk6idalYqC8KVm8=";
          };

          patches = [
            # original version of PR#1813 (syncyomi implementation)
            ./suwayomi-pr-base-1813.patch
            # rebased version
            #./suwayomi-pr-1813.patch
          ];

          outputHash = "sha256-q7NIKUnh4c2A4Otp/8C2lZF+t8KYSy9IEe0Nxbme91g=";
        }
      );
      suwayomi-server = (prev.callPackage <zoeee/pkgs> {}).suwayomi-server.override {
        inherit (final) suwayomi-server-unwrapped;
      };
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

      # Extensions
      extensionRepos = [ "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json" ];
    };
  };

  systemd.services.suwayomi-server = {
    script = lib.mkBefore ''
      ${lib.optionalString (suwayomi.settings.server.syncYomiEnabled or false) ''
        export TACHIDESK_SYNCYOMI_API_KEY="$(<${syncyomi-api-key})"
      ''}
    '';
  };

  sops.secrets.suwayomi = lib.mkIf suwayomi.enable {
    sopsFile = ./suwayomi.secrets.yaml;
    owner = suwayomi.user;
    group = suwayomi.group;
  };

  sops.secrets.syncyomi-api-key = lib.mkIf (suwayomi.settings.server.syncYomiEnabled or false) {
    sopsFile = ./suwayomi.secrets.yaml;
    owner = suwayomi.user;
    group = suwayomi.group;
  };
}
