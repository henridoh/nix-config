{ lib, var, ... }:
{
  services.syncthing = {
    enable = lib.mkDefault true;
    user = "hd";
    settings.folders = {
      sync = {
        path = "/home/hd/Sync";
        type = "sendreceive";
      };
      supernote-note = rec {
        id = "supernote-note";
        path = "/home/hd/Sync/Dokumente/Supernote/Notizen";
        type = "sendreceive";
        devices = var.syncthing.device-names.desktops ++ [ "supernote" ];
        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /home/hd/Sync 0755 hd users - -"
    "L+ /home/hd/Documents - - - - /home/hd/Sync/Dokumente"
    "L+ /home/hd/Desktop - - - - /home/hd/Sync/Desktop"
  ];
}
