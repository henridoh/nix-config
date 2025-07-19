{
  secrets,
  inputs,
  config,
  ...
}:
let
  localAddress = "192.168.100.11";
  secret-folder = "/run/agenix.d/fx-sync";
  secret-path = config.age.secrets.roam-firefox-sync-secret.path;
in
{

  age.secrets.roam-firefox-sync-secret = {
    file = secrets.roam."firefox-sync-secret.age";
    path = "${secret-folder}/firefox-sync-secret";
    symlink = false;
    mode = "440";
    owner = "root";
    group = "root";
  };

  containers.fx-sync-server = {
    autoStart = true;
    privateNetwork = true;

    bindMounts."${secret-folder}".isReadOnly = true;
    hostAddress = "192.168.100.10";
    inherit localAddress;

    config =
      { pkgs, config, ... }:
      {
        system.stateVersion = "24.11";
        networking.firewall = {
          enable = true;
          allowedTCPPorts = [ 80 ];
        };
        services.mysql.package = pkgs.mariadb;

        # FIXME: double proxy not good :(
        services.nginx.enable = true;
        services.firefox-syncserver = {
          enable = true;
          secrets = secret-path;
          singleNode = {
            enable = true;
            hostname = "0.0.0.0";
            url = "https://firefox-syncserver.roam.hdohmen.de";
            enableNginx = true;
          };
        };
      };
  };

  services.nginx.virtualHosts."firefox-syncserver.roam.hdohmen.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${localAddress}";
      recommendedProxySettings = true;
    };
  };
}
