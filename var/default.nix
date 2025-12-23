{ ... }@inputs:
let
  inputs' = inputs // {
    var = outputs;
  };
  # watch out for cycles
  outputs = {
    "lan-dns" = import ./lan-dns.nix inputs';
    "ssh-keys" = import ./ssh-keys.nix inputs';
    "wg" = import ./wg.nix inputs';
  };
in
outputs
