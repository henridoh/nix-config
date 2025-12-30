# Wireguard peers hardcoded in /etc/hosts until I have a nice dns solution
{ lib, var, ... }:
let
  lan-hosts = lib.mapAttrs' (name: value: {
    name = "${name}.lan";
    inherit value;
  }) var.wg.ips;
  custom-hosts = with var.wg.ips; {
    "git.lan" = roam;
    "syncthing.roam.lan" = roam;
  };
in
rec {
  hosts = lan-hosts // custom-hosts;
  hostsFile = lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "${v}\t${n}") hosts);
}
