{ config, ... }:
let
  picoshare = config.services.picoshare;
  adminPass = config.sops.secrets.picoshare;
in {
  imports = [
    <zoeee/modules>
  ];

  services.picoshare = {
    enable = true;
    adminPasswordFile = adminPass.path;
  };

  sops.secrets.picoshare = {
    sopsFile = ./picoshare.secrets.yaml;
  };

  # note: picoshare doesn't support not being at the root, so we can't
  # do `zoeee.net/sh` or something :/
  services.nginx.virtualHosts = {
    "sh.zoeee.net" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString picoshare.port}";
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 10000M;
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
          send_timeout 600s;
        '';
      };
    };
  };
}