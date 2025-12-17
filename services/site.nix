{ ... }: {
  services.nginx.virtualHosts."zoeee.net" = {
    locations."/" = {
      root = "/var/www/zoeee.net";
    };

    # redirect `zoeee.net/feeds` to a folder containing OPML files,
    # so that freshrss can use it as a "dynamic OPML" source
    # (also known as dollar-store-dynamic-OPML)
    locations."/feeds/" = {
      alias = "/var/www/zoeee.net/feeds/";
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
