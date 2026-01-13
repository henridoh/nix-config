{ var, lib, ... }:
let
  inherit (lib.importJSON ./syncthing-managed-clients.json) managed_clients hashes;
  unmanaged = {
    "supernote".id = "3LHXAND-FXDIDWR-7BYAIX4-3GW2BWY-IHTX7HH-LTEDI5T-W7ETGVC-BUP2NAF";
  };
in
assert (
  lib.assertMsg (lib.all (c: lib.elem c (builtins.attrNames hashes))
    managed_clients
  ) "Not all declaratively configured syncthing clients have keys. Rerun ./bin/gen-syncthing-cert"
);
assert (
  lib.assertMsg (
    [ ] == (lib.intersectLists managed_clients (builtins.attrNames unmanaged))
  ) "Syncthing clients must either be unmanaged or declaratively configured."
);
rec {
  managed = builtins.mapAttrs (_: v: { id = v; }) hashes;
  devices = unmanaged // managed;

  device-names = rec {
    all = lib.attrNames devices;
    desktops = (lib.intersectLists var.nixos-desktops all);
  };
}
