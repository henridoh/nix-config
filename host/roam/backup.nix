{
  config,
  pkgs,
  secrets,
  ...
}:
{
  age.secrets.roam-rclone-conf = {
    file = secrets.roam."rclone-conf.age";
    mode = "440";
    owner = "root";
    group = "root";
  };
  systemd = {
    timers."backup-rclone" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        Unit = "backup-rclone.service";
      };
    };
    services."backup-rclone" =
      let
        conf = config.age.secrets.roam-rclone-conf.path;
      in
      {
        script = ''
          ${pkgs.rclone}/bin/rclone --config ${conf} copy /data/sync/documents-hd onedrive:sync
          ${pkgs.rclone}/bin/rclone --config ${conf} copy /git odc:git
        '';
        path = [ pkgs.rclone ];
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
  };
}
