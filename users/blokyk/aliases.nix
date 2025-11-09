let
    # we use `sudo true` because piping `sudo nixos-rebuild`
    # into `nom` hides the password prompt otherwise
    nom-alias = cmd:
        "sudo true && { sudo nixos-rebuild ${cmd} --log-format internal-json -v 2>&1 |& nom --json } && exec $SHELL";
in {
    nom-switch = nom-alias "switch";
    nom-upgrade = nom-alias "switch --upgrade";
    nom-test = nom-alias "test";
}
