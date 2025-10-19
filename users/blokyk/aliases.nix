{
    nom-switch = "sudo true; sudo nixos-rebuild switch --log-format internal-json -v 2>&1 |& nom --json";
    nom-test = "sudo true; sudo nixos-rebuild test --log-format internal-json -v 2>&1 |& nom --json";
}