{
  var,
  config,
  pkgs,
  ...
}:
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

  systemd = {
    timers."backup-rclone" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        Unit = "backup-rclone.service";
      };
    };
    services."backup-rclone" = {
      script = ''
        ${pkgs.rclone}/bin/rclone copy /home/hd/Documents odc:Documents
        ${pkgs.rclone}/bin/rclone copy /git odc:git
      '';
      path = [ pkgs.rclone ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
