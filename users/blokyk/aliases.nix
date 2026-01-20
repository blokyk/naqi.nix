let
  # we use `sudo true` because piping `sudo nixos-rebuild`
  # into `nom` hides the password prompt otherwise
  nom-alias = cmd:
    ''
      sudo true && {
        sudo --preserve-env=NIX_PATH \
          /etc/nixos/bootstrap.sh ${cmd} --no-reexec \
            --log-format internal-json -v 2>&1 \
          |& nom --json
        } &&
      exec sudo --login --user=$USER
    '';
in {
  nom-switch = nom-alias "switch";
  nom-test = nom-alias "test";

  # update the pins and then just do a normal switch
  nom-upgrade = ''
    npins -d /etc/nixos/npins update
  '' + nom-alias "switch";
}
