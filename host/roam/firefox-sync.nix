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
      hostname = "firefox-syncserver.roam.hdohmen.de";
      enableNginx = true;
      enableTLS = true;
    };
  };
}
