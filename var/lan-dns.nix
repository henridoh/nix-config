{ lib, var, ... }:
let
  lan-hosts = lib.mapAttrs' (name: value: {
    name = "${name}.lan";
    inherit value;
  }) var.wg.ips;
  custom-hosts = {
    "fx-sync.lan" = var.wg.ips.roam;
  };
in
rec {
  hostsFile = lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "${v}\t${n}") hosts);
  hosts = lan-hosts // custom-hosts;
}
