{ lib, ... }:
with builtins;
let
  walk-dir-inner =
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
          walk-dir-inner (path + "/${filename}")
        else
          throw "Items of type ${value} are unsupported.";
    }) dir;

  helper-attrs = subpaths: {
    _map = f: lib.mapAttrsRecursive (_: f) subpaths;
  };

  with-helper-attrs =
    x: if isAttrs x then lib.mapAttrs (_: with-helper-attrs) x // helper-attrs x else x;
in
{
  walk-dir = p: with-helper-attrs (walk-dir-inner p);
}
