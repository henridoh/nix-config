{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.hd.desktop.services;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.hd.desktop.services.enable = mkEnableOption "Services";

  config = mkIf cfg.enable {
    services = {
      printing.enable = true;
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      udisks2.enable = true;
      emacs.enable = true;
    };

    home.services.protonmail-bridge = {
      enable = true;
      extraPackages = with pkgs; [
        pass
        gnome-keyring
      ];
    };

    home.services.unison' = {
      # TODO: parameterize
      enable = true;
      pairs = {
        "docs".roots = [
          "/home/hd/Documents"
          "ssh://roam.lan//home/hd/Documents"
        ];
        "desktop".roots = [
          "/home/hd/Desktop"
          "ssh://roam.lan//home/hd/Desktop"
        ];
      };
    };
  };
}
