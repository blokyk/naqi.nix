{ pkgs, lib, ... }:
let
  figlet = lib.getExe pkgs.figlet;
in {
  programs.rust-motd = {
    enable = true;
    enableMotdInSSHD = true;

    settings = {
      banner = {
        color = "cyan";
        command = ''
          echo 'zoeee' | ${figlet} -f larry3d
          echo 'online!' | ${figlet} -f larry3d
        '';
      };

      uptime.prefix = "...since";

      filesystems.root = "/";
      memory.swap_pos = "beside";

      cg_stats = {
        state_file = "cg_stats.toml";
        threshold = 0.01;
      };

      service_status = {
        Suwayomi = "suwayomi-server";
        Immich = "immich-server";
        nginx = "nginx";
        FlareSolverr = "flaresolverr";
      };
    };

    order = [
      "banner" "uptime" "service_status" "filesystems" "memory" "cg_stats" "global"
    ];
  };
}
