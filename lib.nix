{ lib, ... }:
rec {
  # TODO make a version that only includes nix paths.
  walk-dir =
    path:
    let
      dir = builtins.readDir path;
    in
    lib.mapAttrs' (name: value: {
      name = lib.removeSuffix ".nix" name;
      value =
        if value == "regular" then
          path + "/${name}"
        else if value == "directory" then
          walk-dir (path + "/${name}")
        else
          builtins.throw "Items of type ${value} are unsupported.";
    }) dir;

  # Takes a path `p` and returns a flattened lists of all files in that
  # directory, ignoring `p/default.nix`.
  import-recursive = path: lib.attrsets.collect builtins.isPath (walk-dir path // { default = { }; });
}
