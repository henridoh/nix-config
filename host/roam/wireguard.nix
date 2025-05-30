{ var, lib, ... }:
let
  wireguard-port = 51820;
in
{
  networking = {
    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg0" ];
    };

    firewall.allowedUDPPorts = [ wireguard-port ];

    wireguard = {
      enable = true;
      interfaces."wg0" = {
        ips = var.wg.wireguard-network."roam".ips;
        listenPort = wireguard-port;
        privateKeyFile = var.wg.keyFile;
        peers = var.wg.peers-for "roam";
      };
    };
  };
}
