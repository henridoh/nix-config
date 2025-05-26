{ config, ... }:
let
  headscale-domain = "headscale.hdohmen.de";
in
{
  services = {
    nginx = {
      enable = true;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
  };
}
