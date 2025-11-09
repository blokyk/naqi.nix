{ ... }: {
  services.nginx.virtualHosts."zoeee.net" = {
    forceSSL = true;
    enableACME = true;
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
