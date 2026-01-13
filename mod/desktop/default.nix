{
  lib,
  config,
  ...
}:
with lib;
{
  options.home = lib.mkOption {
    # used by /home/default.nix
    type = lib.types.attrsOf lib.types.str;
    default = { };
    description = "Home Manager configuration for user `hd`. Has no effect if `/home` is not loaded";
  };

  options.hd.desktop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Common NixOS configuration of all desktops.";
    };

    audio = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.desktop.enable;
        description = "Enable audio configuration";
      };
    };

    gpg = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.desktop.enable;
        description = "Enable GPG configuration";
      };
    };

    network = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.desktop.enable;
        description = "Enable network configuration";
      };
    };

    security = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.desktop.enable;
        description = "Enable desktop security configuration";
      };
    };

    software = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.desktop.enable;
        description = "Enable software installation";
      };

      development = {
        enable = mkOption {
          type = types.bool;
          default = config.hd.desktop.software.enable;
          description = "Enable development software";
        };
      };
    };

    windowManager = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.desktop.enable;
        description = "Enable window manager configuration";
      };
    };

    accounts = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.desktop.enable;
        description = "Enable desktop user accounts";
      };
    };

    fonts = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.desktop.enable;
        description = "Enable font configuration";
      };
    };

    services = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.desktop.enable;
        description = "Enable desktop services";
      };
    };
  };

  imports = [
    ./accounts.nix
    ./audio.nix
    ./fonts.nix
    ./gpg.nix
    ./network.nix
    ./security.nix
    ./services.nix
    ./software
    ./syncthing.nix
    ./window-manager.nix
  ];

  config = mkIf config.hd.desktop.enable {
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
      ];

    programs.nix-ld.enable = true;
  };
}
