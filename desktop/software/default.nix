{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hd.desktop.software;
  inherit (lib) mkEnableOption mkIf;
in
{
  imports = [ ./development.nix ];

  options.hd.desktop.software.enable = mkEnableOption "Software";

  config = mkIf cfg.enable {
    hd.desktop.software.development.enable = true;

    environment.systemPackages = with pkgs; [
      # vesktop
      bitwarden
      calibre
      element-desktop
      gh
      kitty
      nil
      obsidian
      rclone
      signal-desktop
      spotify
      starship
      stow
      tor-browser
      vlc
      wireguard-tools
      wl-clipboard
      zotero
      zulip
    ];

    virtualisation = {
      docker.enable = true;
    };

    programs = {
      firefox.enable = true;
      git.enable = true;
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
