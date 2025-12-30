{ var, lib, ... }:
let
  inherit (var.syncthing-managed-clients) managed_clients hashes;
  unmanaged = {
    "supernote".id = "3LHXAND-FXDIDWR-7BYAIX4-3GW2BWY-IHTX7HH-LTEDI5T-W7ETGVC-BUP2NAF";
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
