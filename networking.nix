{ config, ... }:

{
   # fixme: find out WHY ens3 stays on configuring (and thus blocks `wait-online` & boot/switch) even when its configured (maybe ipv4/6 dhcp/rad/ndp problems?)
  systemd.network.wait-online.enable = false;

  networking = {
  useNetworkd = true;
  useDHCP = false;
  dhcpcd.enable = false;

  enableIPv6 = true;

  interfaces.ens3 = {
    ipv4.addresses = [{
      address = "77.90.19.122";
      prefixLength = 24;
    }];
    ipv6.addresses = [{
      address = "2a0d:5940:112:2a::a";
      prefixLength = 64;
    }];
  };

  defaultGateway = {
    address = "77.90.19.1";
    interface = "ens3";
  };
  defaultGateway6 = {
    address = "2a0d:5940:112::1";
    interface = "ens3";
  };

  nameservers = [
    "9.9.9.9"
    "8.8.4.4"
  ];
};}
