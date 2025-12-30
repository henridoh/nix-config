{ lib, var, ... }:
with builtins;
rec {
  walk-dir =
    path:
    let
      dir = readDir path;
    in
    lib.mapAttrs' (filename: value: {
      name = lib.removeSuffix ".nix" filename;
      value =
        if value == "regular" then
          path + "/${filename}"
        else if value == "directory" then
          walk-dir (path + "/${filename}")
        else
          throw "Items of type ${value} are unsupported.";
    }) dir;

  is-desktop = x: builtins.elem x var.desktops;
  is-server = x: builtins.elem x var.servers;
}
