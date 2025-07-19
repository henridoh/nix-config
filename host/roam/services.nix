{
  var,
  ...
}:
{
  services = {
    nginx = {
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;
      recommendedZstdSettings = true;
      recommendedOptimisation = true;

      enable = true;
      virtualHosts.default = {
        serverName = "_";
        default = true;
        rejectSSL = true;
        locations."/".return = "444";
      };
      virtualHostsPriv."roam.lan" = {
        locations."/" = { };
      };
      virtualHosts."roam.hdohmen.de" = {
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
