{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.software;
  inherit (lib) mkEnableOption mkIf;
in
{
  imports = [ ./development.nix ];

  options.desktop.software.enable = mkEnableOption "Software";

  config = mkIf cfg.enable {
    desktop.software.development.enable = true;

    environment.systemPackages = with pkgs; [
      # vesktop
      bitwarden
      calibre
      element-desktop
      kitty
      nil
      obsidian
      rclone
      signal-desktop
      spotify
      tor-browser
      vlc
      wireguard-tools
      zotero
      zulip
    ];

    virtualisation = {
      docker.enable = true;
    };

    programs = {
      firefox.enable = true;
      kdeconnect.enable = true;
    };

    home = {
      programs.thunderbird = {
        enable = true;
        package = pkgs.thunderbird-latest;
        profiles.default = {
          isDefault = true;
          withExternalGnupg = true;
        };
      };
    };

    # Some excludes
    services.xserver.excludePackages = [ pkgs.xterm ];
  };
}
