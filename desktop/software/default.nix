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
      programs.git = {
        enable = true;
        signing = {
          signByDefault = true;
          signer = "openpgp";
          key = "AB79213B044674AE";
        };
        userName = "Henri Dohmen";
        userEmail = "henridohmen@posteo.com";
        extraConfig = {
          color.ui = "auto";
          column.ui = "auto";
          branch.sort = "-committerdate";
          alias = {
            staash = "stash --all";
          };
          core = {
            editor = "nvim";
            autocrlf = "input";
          };
          init.defaultBranch = "main";
          credential.helper = "libsecret";
        };
      };
      programs.foot = {
        enable = true;
        server.enable = true;
      };
    };

    # Some excludes
    services.xserver.excludePackages = [ pkgs.xterm ];
  };
}
