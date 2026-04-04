{ config, ... }: {
  services.ntfy-sh = {
    enable = true;
    settings = rec {
      port = 2586;
      listen-http = ":${toString port}"; # can't use cfg.settings.port because cfg.settings is freeform
      base-url = "https://ntfy.${config.services.hostrr.base}/";
      behind-proxy = true;
      auth-default-access = "write-only";
    };
  };

  services.ntfy-sh.environmentFile = config.sops.templates."ntfy-users.env".path;
  sops.templates."ntfy-users.env".content = ''
    NTFY_AUTH_USERS='blokyk:${config.sops.placeholder.ntfy}:admin'
  '';

  sops = {
    secrets.ntfy = {
      sopsFile = ./ntfy.secrets.yaml;
    };
  };
}
