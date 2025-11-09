{ ... }:
let
  loq15_ahp9_key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOM7GQ43sqT5fVIkS7QvW3PcfPX9xJ6l6MY1IFSNFUhD blokyk";
in {
  users.users.root = {
    openssh.authorizedKeys.keys = [ loq15_ahp9_key ];
  };
}
