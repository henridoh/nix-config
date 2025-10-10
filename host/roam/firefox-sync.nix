{
  pkgs,
  pkgs-stable,
  config,
  secrets,
  ...
}:
{
  services.mysql.package = pkgs.mariadb;

  # TODO: containerize
  age.secrets.roam-firefox-sync-secret = {
    file = secrets.roam."firefox-sync-secret.age";
    mode = "440";
    owner = "root";
    group = "root";
  };

  services.firefox-syncserver = {
    enable = true;
    package = pkgs-stable.syncstorage-rs;
    secrets = config.age.secrets.roam-firefox-sync-secret.path;
    singleNode = {
      enable = true;
      hostname = "firefox-syncserver.roam.hdohmen.de";
      enableNginx = true;
      enableTLS = true;
    };
  };
}
