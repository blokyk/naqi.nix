{ pkgs, ... }:
let
  commit = "524312bc62e3f34bd9231a2f66622663d3355133";
  sops-nix = builtins.fetchTarball {
    url = "https://github.com/Mic92/sops-nix/archive/${commit}.tar.gz";
    # replace this with an actual hash
    sha256 = "0qm4vglp47bw25ppdnsv3jnf5mwggkk7ssd8n9i59y2z0fcgdayq";
  };
in {
  imports = [
    "${sops-nix}/modules/sops"
  ];

  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  # automatically import the server's host (private) key
  # !! MUST BE A STRING !! or it'll end up in the nix store...
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # use an existing age key or generate one if it doesn't exist yet
  # !! MUST BE A STRING !! or it'll end up in the nix store...
  sops.age.keyFile = "/var/lib/sops-nix/keys.txt";
  sops.age.generateKey = true;

  # cf https://github.com/Mic92/sops-nix/blob/d75e4f89e58fdda39e4809f8c52013caa22483b7/README.md#set-secret-permissionowner-and-allow-services-to-access-it
  #  & https://github.com/Mic92/sops-nix/blob/d75e4f89e58fdda39e4809f8c52013caa22483b7/README.md#restartingreloading-systemd-units-on-secret-change
  sops.secrets = {};
}