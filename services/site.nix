{ config, lib, pkgs, ... }:

{
  services.nginx.virtualHosts."zoeee.net" = {
    locations."/" = {
      root = "/var/www/zoeee.net";
    };

    # todo: robots.txt
    # locations."/robots.txt" = {
    #   extraConfig = ''
    #     rewrite ^/(.*)  $1;
    #     return 200 "User-agent: *\nDisallow: /";
    #   '';
    # };
  };
}
