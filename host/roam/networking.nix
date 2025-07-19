{ var, ... }:
let
  wireguard-port = 51820;
in

{
  networking = {
    enableIPv6 = true;

    interfaces = {
      "ens3".ipv6.addresses = [
        {
          address = "2a03:4000:3b:f99::";
          prefixLength = 64;
        }
      ];
    };

    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };

    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [
        "wg0"
        "ve-+"
      ];
      enableIPv6 = true;
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
