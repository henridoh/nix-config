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

  folders = {
    sync = {
      id = "documents-hd"; # don't change ID
      path = lib.mkDefault (builtins.throw "You must set services.syncthing.folders.sync.path!!!");
      type = lib.mkDefault (builtins.throw "You must set services.syncthing.folders.sync.type!!!");

      # all clients (desktops + servers) that have are a synthing peer but
      # with untrusted servers
      devices =
        var.syncthing.device-names.desktops
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
    assert lib.assertMsg (builtins.elem this var.syncthing.device-names.all)
      "${this} is not in devices in mod/syncthing.nix";
    {
      settings = {
        inherit folders;
        devices = var.syncthing.devices;
      };
      key = lib.optionalAttrs is-managed config.age.secrets.syncthing-key.path;
      cert = lib.optionalAttrs is-managed "${../pki/syncthing + "/${this}.cert"}";
    }
  );
}
