{
  lib ? null,
}:
let
  lib' = if builtins.isNull lib then (import <nixpkgs> { }).lib else lib;
  inputs' = {
    lib = lib';
    var = outputs;
  };
  load-var = x: import x inputs';
  # watch out for cycles
  outputs = {
    "lan-dns" = load-var ./lan-dns.nix;
    "ssh-keys" = load-var ./ssh-keys.nix;
    "wg" = load-var ./wg.nix;
    "syncthing" = load-var ./syncthing.nix;
    "syncthing-managed-clients" = lib'.importJSON ./syncthing-managed-clients.json;
  };
in
outputs
