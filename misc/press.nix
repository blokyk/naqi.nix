{ ... }:
let
  press = builtins.fetchGit {
    url = "https://github.com/RossSmyth/press";
    rev = "8fab9f53a11e15a955a4a565d4a03ba0a7b728c8";
    shallow = true;
  };
in {
  nixpkgs.overlays = [ (import press) ];
}