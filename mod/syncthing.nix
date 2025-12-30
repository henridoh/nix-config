{
  var,
  config,
  lib,
  secrets,
  ...
}:
let
  cfg = config.services.syncthing;
  this = config.networking.hostName;

  is-managed = builtins.elem this var.syncthing-managed-clients.managed_clients;
  is-server = this == "roam";

  devices = [
    "roam"
    "fw"
  ];

  devices-without-this = lib.remove this devices;
  type-encrypt = if is-server then "receiveencrypted" else "sendreceive";
  devices-encrypt =
    if is-server then
      devices-without-this
    else
      lib.remove "roam" devices-without-this
      ++ [
        {
          name = "roam";
          encryptionPasswordFile = config.age.secrets.syncthing-password.path;
        }
      ];

  folders = {
    documents = {
      id = "documents-hd";
      path = if is-server then "/data/sync/documents-hd" else "/home/hd/Documents";
      type = type-encrypt;
      devices = devices-encrypt;
      versioning = {
        type = "simple";
        params.keep = "10";
      };
    };
    supernote-note = rec {
      id = "supernote-note";
      path = if is-server then "/data/sync/${id}" else "/home/hd/Documents/Supernote/Notizen";
      type = "sendreceive";
      devices = devices-without-this ++ [ "supernote" ];
      versioning = {
        type = "simple";
        params.keep = "10";
      };
    };
  };
in
{
  age.secrets.syncthing-password = lib.mkIf (cfg.enable && !is-server) {
    file = secrets."syncthing-password.age";
    mode = "440";
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
  };

  age.secrets.syncthing-key = lib.mkIf (cfg.enable && is-managed) {
    file = secrets.syncthing."${this}.age";
    mode = "440";
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
  };

  services.syncthing = lib.mkIf cfg.enable (
    assert lib.assertMsg (builtins.elem this devices) "${this} is not in devices in mod/syncthing.nix";
    {
      inherit folders;
      settings = {
        devices = var.syncthing;
      };
      key = lib.optionalAttrs is-managed config.age.secrets.syncthing-key.path;
      cert = lib.optionalAttrs is-managed "${../pki/syncthing + "/${this}.cert"}";
    }
  );
}
