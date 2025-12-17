{ ... }:
let
  press = builtins.fetchGit {
    url = "https://github.com/RossSmyth/press";
    rev = "2807d1ed2315f971ccc6c61501f6bc0aaa0cb1bf";
    shallow = true;
  };
in {
  nixpkgs.overlays = [ (import press) ];
}