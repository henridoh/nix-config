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

  is-managed = var.syncthing.managed ? ${this};
  is-server = this == "roam";

  devices = lib.attrNames var.syncthing.all;
  desktop-devices = (lib.intersectLists var.nixos-desktops devices);

  folders = folders-all // (if config.hd.desktop.enable then folders-desktop else { });

  folders-all = {
    documents = {
      id = "documents-hd";
      path = if is-server then "/data/sync/documents-hd" else "/home/hd/Documents";
      type = if is-server then "receiveencrypted" else "sendreceive";
      # all clients (desktops + servers) that have are a synthing peer but
      # with untrusted servers
      devices =
        desktop-devices
        ++ (
          if this != "roam" then
            [
              {
                name = "roam";
                encryptionPasswordFile = config.age.secrets.syncthing-password.path;
              }
            ]
          else
            [ ]
        );
      versioning = {
        type = "simple";
        params.keep = "10";
      };
    };
  };

  folders-desktop = {
    supernote-note = rec {
      id = "supernote-note";
      path = if is-server then "/data/sync/${id}" else "/home/hd/Documents/Supernote/Notizen";
      type = "sendreceive";
      devices = desktop-devices ++ [ "supernote" ];
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
        devices = var.syncthing.all;
      };
      key = lib.optionalAttrs is-managed config.age.secrets.syncthing-key.path;
      cert = lib.optionalAttrs is-managed "${../pki/syncthing + "/${this}.cert"}";
    }
  );
}
