{ ... }:
let
  wireguard-port = 51820;
  wireguard-subnet = "100.10.11.0/24";
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
        ips = [ wireguard-subnet ];
        listenPort = wireguard-port;
        privateKeyFile = "/var/secrets/wg0.key";
      };
    };
  };
}
