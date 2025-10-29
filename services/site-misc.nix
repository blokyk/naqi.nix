# a few resources i want to serve with a short link for misc reasons

{ config, lib, pkgs, ... }:

{
  services.nginx.virtualHosts."zoeee.net" = {
    locations."/shrug" = {
      return = ''
         200 '¯\_(ツ)_/¯'
      '';
      extraConfig = ''
        default_type text/plain;
        charset utf-8;
      '';
    };

    locations."=/brrr" = {
      alias = "/var/www/brrr.opus";
      extraConfig = ''
        default_type audio/ogg;
        try_files ''$uri =404;
      '';
    };
  };
}
