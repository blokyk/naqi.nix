{ config, lib, ... }:
let
  adminPass = config.sops.secrets.picoshare;
  picoshare = config.services.picoshare;
in {
  services.picoshare = {
    enable = true;
    adminPasswordFile = adminPass.path;
  };

  sops.secrets.picoshare = lib.mkIf picoshare.enable {
    sopsFile = ./picoshare.secrets.yaml;
  };
}