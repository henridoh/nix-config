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
      file
      fuzzel
      gh
      nil
      signal-desktop
      spotify-player
      tor-browser
      usbutils
      vlc
      wireguard-tools
      wl-clipboard
      yt-dlp
      zotero
      zulip
    ];

    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    programs.kdeconnect.enable = true;

    home = {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set -U fish_greeting
          starship init fish | source
        '';
      };
      programs.starship = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          format = "[$username](green)@[$hostname](red)[\\[$directory\\]](cyan bold) $all";
          username = {
            show_always = true;
            format = "$user";
          };
          hostname = {
            ssh_only = false;
            format = "$hostname";
          };
          directory.format = "$path";
          character = {
            format = "$symbol ";
            success_symbol = "\\\$";
            error_symbol = "[\\\$](red)";
          };
          git_branch.format = "[$symbol$branch(:$remote_branch)]($style)";
        };
      };
      programs.librewolf = {
        enable = true;
        settings = {
          "identity.fxaccounts.enabled" = true;
          "identity.sync.tokenserver.uri" = "https://firefox-syncserver.roam.hdohmen.de/1.0/sync/1.5";
          "privacy.resistFingerprinting" = true;
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "privacy.spoof_english" = 2;
          "privacy.resistFingerprinting.block_mozAddonManager" = true;
          "network.http.sendRefererHeader" = 1;
          "intl.accept_languages" = "en,en-us";
          "privacy.resistFingerprinting.letterboxing" = true;
        };
      };
      programs.thunderbird = {
        enable = true;
        package = pkgs.thunderbird-latest;
        profiles.default = {
          isDefault = true;
          withExternalGnupg = true;
          settings = {
            "intl.date_time.pattern_override.date_short" = "yyyy-MM-dd";
            "mail.html_compose" = false;
            "mail.identity.default.compose_html" = false;
          };
        };
      };
      programs.git = {
        enable = true;
        signing = {
          signByDefault = true;
          signer = "openpgp";
          key = "AB79213B044674AE";
        };
        settings = {
          user.name = "Henri Dohmen";
          user.email = "henridohmen@posteo.com";
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
          };
        };
      };
    };

    # Some excludes
    services.xserver.excludePackages = [ pkgs.xterm ];
  };
}
