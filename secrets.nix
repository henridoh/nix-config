let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) lib;
  keys = (import ./var { inherit lib; }).ssh-keys.root;
  secrets = [
    "roam/rclone-conf"
    "roam/firefox-sync-secret"
    "hd-password"
  ];
in
builtins.foldl' (acc: x: acc // { "secrets/${x}.age".publicKeys = keys; }) { } secrets
