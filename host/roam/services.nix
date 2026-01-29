{
  pkgs,
  ...
}:
{
  services = {
    nginx = {
      enable = true;

      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedOptimisation = true;

      virtualHosts.default = {
        serverName = "_";
        default = true;
        rejectSSL = true;
        locations."/".return = "444";
      };
      privateVirtualHosts."roam.lan" = {
        locations."/" = { };
      };
      virtualHosts."roam.hdohmen.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = { };
      };
    };

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    minecraft-server = {
      enable = true;
      package = pkgs.papermcServers.papermc-1_21_9;
      eula = true;
      declarative = true;
      serverProperties = {
        level-seed = "hd";
        difficulty = 3;
        spawn-protection = 0;
        server-ip = "0.0.0.0";
      };
      jvmOpts = "-Xms2048M -Xmx4096M";
    };
  };

}
