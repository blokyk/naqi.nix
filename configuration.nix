# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

let
  mypkgs = import <zoeee/pkgs> {};
in {
  # on a new system, you might need to do
  #   nix-channel --add 'https://github.com/blokyk/packages.nix' zoeee
  # before invoking `nixos-rebuild`

  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./nix.nix

    ./misc
    ./services
    ./users

    <zoeee/modules>
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # o7
  networking.domain = "zoeee.net";
  networking.hostName = "naqi";

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     # font = "Lat2-Terminus16";
     keyMap = "fr";
  };

  # global environment variables
  environment.variables = {
    EDITOR = "nano";
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    nano
    vim
    wget
    git
    openssh
    figlet
    file
    htop
    bat
    dig
    nixd
    netop
    traceroute
    mypkgs.picoshare
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable Nix-ld for non-nixified binaries (e.g. vscode server)
  programs.nix-ld.enable = true;

  # List services that you want to enable:

  # Enable nginx, but let other parts of the config (e.g. immich, suwayomi, etc) set it up
  services.nginx.enable = true;

  # don't require sudoers to type in passwords for sudo
  #
  # we only allow ssh key-based auth anyway, so only way in is through
  # getting access to the blokyk account, but it doesn't run any service so
  # i fail to see what attack vector there is (other than a bug in the kernel)
  security.sudo.wheelNeedsPassword = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;

   settings = {
      # only allow authorized_keys-based auth for ssh
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      # try to keep connection alive
      ClientAliveInterval = 30;
      ClientAliveCountMax = 3;
      TCPKeepAlive = true;
    };
  };

  # Enable mosh, the mobile shell; a better remote shell built atop SSH
  # Opens UDP ports [60_000..61_000]
  programs.mosh.enable = true;

  # Enable QEMU guest integrations
  services.qemuGuest.enable = true;

  # Open ports in the firewall.
  # (most services open ports themselves through `.openFirewall` options)
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];	# SSH + HTTP+HTTPS
  networking.firewall.allowedUDPPorts = [ 53 ];     	# DNS
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

