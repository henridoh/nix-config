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
  outputs = rec {
    # We list the hosts here manually instead of getting them from the flake.
    # This way, var can be used standalone
    nixos-desktops = [
      "c2"
      "fw"
      "solo"
    ];
    nixos-servers = [ "roam" ];
    nixos-hosts = nixos-desktops ++ nixos-servers;

    "lan-dns" = load-var ./lan-dns.nix;
    "ssh-keys" = load-var ./ssh-keys.nix;
    "wg" = load-var ./wg.nix;
    "syncthing" = load-var ./syncthing.nix;
  };
in
outputs
