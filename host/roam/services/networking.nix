{ ... }:
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

    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
    };
  };
}
