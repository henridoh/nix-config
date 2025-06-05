{ var, config, ... }:
let
  headscale-domain = "headscale.hdohmen.de";
in
{
  services = {
    nginx = {
      enable = true;
      defaultListen = [
        {
          addr = var.wg.ips.roam;
          ssl = true;
        }
      ];
      virtualHosts."roam.lan" = {
        locations."/" = { };
      };
      virtualHostsPub."roam.hdohmen.de" = {
        enableACME = true;
        locations."/" = { };
      };
    };

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
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
