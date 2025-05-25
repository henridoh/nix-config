{ lib, ... }:
rec {
  walk-dir =
    path:
    let
      dir = builtins.readDir path;

      subpaths = lib.mapAttrs' (filename: value: {
        name = lib.removeSuffix ".nix" filename;
        value =
          if value == "regular" then
            path + "/${filename}"
          else if value == "directory" then
            walk-dir (path + "/${filename}")
          else
            builtins.throw "Items of type ${value} are unsupported.";
      }) dir;
    in
    subpaths
    // rec {
      _files = lib.collect builtins.isPath (subpaths // { default = { }; });
      _nix_files = builtins.filter (lib.hasSuffix ".nix") _files;
      _nixos_mod =
        { ... }:
        {
          imports = _nix_files;
        };
    };

  # Takes a path `p` and returns a list of all files in that
  # directory recursively, ignoring `p/default.nix`.
  import-recursive = path: (walk-dir path)._files;
}
