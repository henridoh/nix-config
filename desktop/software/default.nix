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
      # kitty
      # niri
      # obsidian
      # vesktop
      bitwarden
      calibre
      element-desktop
      fuzzel
      gh
      nil
      rclone
      signal-desktop
      spotify-player
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

    programs.kdeconnect.enable = true;

    home = {
      programs.librewolf = {
        enable = true;
        settings = {
          "identity.fxaccounts.enabled" = true;
          "identity.sync.tokenserver.uri" = "http://fx-sync.lan/1.0/sync/1.5";
          "webgl.disabled" = false;
          "privacy.resistFingerprinting" = false;
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown.cookies" = false;
          "network.cookie.lifetimePolicy" = 0;
        };
      };
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
        settings = {
          main = {
            "font" = "monospace:size=11";
            "dpi-aware" = "yes";
          };
        };
      };
    };

    # Some excludes
    services.xserver.excludePackages = [ pkgs.xterm ];
  };
}
