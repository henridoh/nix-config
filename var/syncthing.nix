{ var, lib, ... }:
let
  inherit (var.syncthing-managed-clients) managed_clients hashes;
  unmanaged = {
    # "roam".id = "OIKOKOT-LY4JWPX-T7OXE4D-I4ZC3IR-ZLMKFCO-IXSVEYZ-Y3FZOUB-LIG2XAO";
  };
in
assert (
  lib.assertMsg (
    builtins.attrNames hashes == managed_clients
  ) "Not all declaratively configured syncthing clients have keys. Rerun ./bin/gen-syncthing-cert"
);
assert (
  lib.assertMsg (
    [ ] == (lib.intersectLists managed_clients (builtins.attrNames unmanaged))
  ) "Syncthing clients must either be unmanaged or declaratively configured."
);
unmanaged // builtins.mapAttrs (_: v: { id = v; }) hashes
