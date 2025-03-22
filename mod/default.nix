{ lib, ... }:

let
  walk =
    path:
    let
      dir = builtins.readDir path;
    in
    lib.mapAttrs' (name: value: {
      name = lib.removeSuffix ".nix" name;
      value =
        if value == "regular" then
          import (path + "/${name}")
        else if value == "directory" then
          walk (path + "/${name}")
        else
          builtins.throw "Cannot handle item of type ${value}";
    }) dir;

in
walk ./.
