{ ... }:
let
  guiAddress = "127.0.0.1:8384";
in
{
  services.syncthing = {
    enable = true;
    inherit guiAddress;
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
