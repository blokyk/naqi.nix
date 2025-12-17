{ config, ... }:
let
  adminPass = config.sops.secrets.picoshare;
in {
  services.picoshare = {
    enable = true;
    adminPasswordFile = adminPass.path;
  };

  sops.secrets.picoshare = {
    sopsFile = ./picoshare.secrets.yaml;
  };
}