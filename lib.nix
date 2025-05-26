{ lib, ... }:
with builtins;
let
  lib' = rec {
    walk-dir =
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

        helper-attrs =
          subpaths:
          let
            _files = lib.collect (x: isPath x || isString x) subpaths;
            _nix_files = filter (lib.hasSuffix ".nix") _files;
          in
          rec {
            to_mod = _: {
              imports = _nix_files;
            };
            to_mod_without_default = without_default.to_mod;
            collect_nix_files = _nix_files;
            map_import = lib.mapAttrsRecursive (_: import) subpaths;
            map_import_with_lib = lib.mapAttrsRecursive (_: x: (import x) { inherit lib lib'; }) subpaths;
            without_default =
              let
                subpaths' = removeAttrs subpaths [ "default" ];
              in
              with-helper-attrs subpaths';
          };

        with-helper-attrs =
          x: if isAttrs x then lib.mapAttrs (_: with-helper-attrs) x // helper-attrs x else x;
      in
      p: with-helper-attrs (walk-dir-inner p);
  };
in
lib'
