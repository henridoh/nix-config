{
  var,
  config,
  secrets,
  ...
}:
let
  wireguard-port = 51820;
in

{
  age.secrets.mullvad-vpn-key = {
    file = secrets.roam."mullvad-vpn-key.age";
    owner = "root";
    group = "root";
    mode = "440";
  };

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

    firewall = {
      enable = true;
      interfaces."wg0" = {
        allowedTCPPorts = [ 25565 ];
      };
      allowedTCPPorts = [
        80
        443
      ];
    };

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
      interfaces."mullvad" = {
        ips = [
          "10.69.173.41/32"
          "fc00:bbbb:bbbb:bb01::6:ad28/128"
        ]; # free cat
        privateKeyFile = config.age.secrets.mullvad-vpn-key.path;
        peers = [
          {
            name = "de-fra-wg-007";
            publicKey = "mTmrSuXmTnIC9l2Ur3/QgodGrVEhhIE3pRwOHZpiYys=";
            allowedIPs = [ ];
            endpoint = "de-fra-wg-007.relays.mullvad.net:51820";
          }
        ];
      };
    };

  };

}
