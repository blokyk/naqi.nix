{ lib, ...}: {
    # import all files in this folder ending in '*.nix' (except default.nix)
    imports = lib.filter
        (file: (lib.hasSuffix ".nix" file) && (baseNameOf file != "default.nix"))
        (lib.filesystem.listFilesRecursive ./.);
}