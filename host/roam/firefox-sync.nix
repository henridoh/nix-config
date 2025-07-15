{
  pkgs,
  config,
  secrets,
  ...
}:
{
  services.mysql.package = pkgs.mariadb;

  age.secrets.roam-firefox-sync-secret = {
    file = secrets.roam."firefox-sync-secret.age";
    mode = "440";
    owner = "root";
    group = "root";
  };

  services.firefox-syncserver = {
    enable = true;
    secrets = config.age.secrets.roam-firefox-sync-secret.path;
    singleNode = {
      enable = true;
      hostname = "fx-sync.lan";
      enableTLS = false;
    };
  };
  services.nginx.virtualHostsPriv."fx-sync.lan" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.firefox-syncserver.settings.port}";
      recommendedProxySettings = true;
    };
  };
}
