{ config, lib, pkgs, ... }:

{
  services.nginx.virtualHosts."zoeee.net" = {
    locations."/" = {
      return = ''
        200 '<html><body><h1>hello, world!</h1> <br/>-- from <code style="font-size: 1.3em">naqi</code></body></html>'
      '';
      extraConfig = ''
        default_type text/html;
      '';
    };
  };
}
