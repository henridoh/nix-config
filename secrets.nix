let
  keys =
    let
      k = (import ./var/ssh-keys.nix { });
    in
    k.root; # ++ k.hd;
  secrets = [
    "roam/rclone-conf"
    "hd-password"
  ];
in
builtins.foldl' (acc: x: acc // { "secrets/${x}.age".publicKeys = keys; }) { } secrets
