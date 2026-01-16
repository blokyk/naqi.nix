{ ... }:
let
  press = fetchTarball {
    url = "https://github.com/RossSmyth/press/archive/2807d1ed2315f971ccc6c61501f6bc0aaa0cb1bf.tar.gz";
    sha256 = "sha256-MVYF/c1YXzS4BO0BkSVPKbBh69g2t0kniMq0oS10198=";
  };
in {
  nixpkgs.overlays = [ (import press) ];
}