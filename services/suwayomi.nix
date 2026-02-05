{ config, lib, ... }:
let
  suwayomi = config.services.suwayomi-server;
  passwdFile = config.sops.secrets.suwayomi.path;

  flare = config.services.flaresolverr;
in {
  nixpkgs.overlays = [(
    final: prev: {
      suwayomi-server-unwrapped = (prev.callPackage <zoeee/pkgs> {}).suwayomi-server-unwrapped.overrideAttrs (
        finalAttrs: _: {
          version = "2.1.2056";
          rev = "02da884f176e51c9ced8a95fa0954b4906522de7";

          outputHash = "sha256-facd4Ifo0HTEC3J5kBpTt67qYD7BQocp4cMkxv5UrU0=";

          # specifically fetch the jar artifact
          src = prev.fetchFromGitHub {
            owner = "Suwayomi";
            repo = "Suwayomi-Server";
            rev = finalAttrs.rev;
            hash = "sha256-M1S40zp4/zlixMhXD/HhfJtIE3UlNk4cVeYoKCOrYi8=";
          };
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
