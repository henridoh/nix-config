let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) lib;
  ssh-keys = (import ./var { inherit lib; }).ssh-keys;
  keys = ssh-keys.root;
  trusted-keys = ssh-keys.trusted-root;
  secrets = [
    "roam/rclone-conf"
    "roam/firefox-sync-secret"
    "hd-password"
    "tlskey"
  ];
  trusted-secrets = [
    # Can only be decrypted by clients
    "syncthing-password"
  ];
  mkSecrets =
    keys: secrets: lib.mergeAttrsList (map (x: { "secrets/${x}.age".publicKeys = keys; }) secrets);
  syncthingManagedClients = (lib.importJSON ./var/syncthing-managed-clients.json).managed_clients;
  mkSyncthingSecret = client: {
    "secrets/syncthing/${client}.age".publicKeys = [ ssh-keys.by-host.root.${client} ];
  };
  syncthingSercrets = lib.mergeAttrsList (map mkSyncthingSecret syncthingManagedClients);
in
lib.mergeAttrsList ([
  (mkSecrets keys secrets)
  (mkSecrets trusted-keys trusted-secrets)
  (syncthingSercrets)
])
