{ lib, var, ... }:
let
  lan-tld = ".lan";
  lan-base-domain = ".hdohmen.de";
  lan-hosts = lib.mapAttrs' (name: value: {
    name = "${name}${lan-tld}";
    inherit value;
  }) var.wg.ips;
in
rec {
  hostsFile = lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "${v}\t${n}") hosts);
  hosts =
    lan-hosts
    // lib.mapAttrs' (name: value: {
      name = "${name}${lan-base-domain}";
      inherit value;
    }) lan-hosts;
}
