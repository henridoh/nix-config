{
  pkgs,
  secrets,
  config,
  ...
}:
let
  hostName = "nextcloud.hdohmen.de";
in
{
  services.nextcloud = {
    enable = true;
    inherit hostName;
    package = pkgs.nextcloud32;
    https = true;
    configureRedis = true;
    datadir = "/data/nextcloud";
    database.createLocally = true;
    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        news
        contacts
        calendar
        tasks
        ;
    };
    config = {
      adminuser = "admin";
      adminpassFile = config.age.secrets.nextcloud-admin-password.path;
      dbtype = "pgsql";
    };
  };

  services.nginx.virtualHosts.${hostName} = {
    enableACME = true;
    forceSSL = true;
  };

  age.secrets.nextcloud-admin-password = {
    file = secrets.roam."nextcloud-admin-password.age";
    owner = "nextcloud";
    group = "nextcloud";
    mode = "440";
  };
}
