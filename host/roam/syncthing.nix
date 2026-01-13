{ ... }:
let
  guiAddress = "127.0.0.1:8384";
in
{
  services.syncthing = {
    enable = true;
    inherit guiAddress;

    settings.folders.sync = {
      path = "/data/sync/documents-hd";
      type = "receiveencrypted";
    };
  };

  services.nginx = {
    privateVirtualHosts."syncthing.roam.lan" = {
      locations."/" = {
        proxyPass = "http://${guiAddress}/";
        proxyWebsockets = true;
      };
    };
  };
}
