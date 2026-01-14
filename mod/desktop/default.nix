{
  lib,
  config,
  ...
}:
with lib;
let
  mkSubOption =
    of: name:
    mkOption {
      type = types.bool;
      default = of;
      description = "Enables" ++ name;
    };
  mkDesktopOption = mkSubOption config.hd.desktop.enable;
in
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

    audio.enable = mkDesktopOption "audio configuration";
    gpg.enable = mkDesktopOption "GPG configuration";
    network.enable = mkDesktopOption "network configuration";
    security.enable = mkDesktopOption "security configuration";
    software = {
      enable = mkDesktopOption "software installation";
      development.enable = mkSubOption config.hd.desktop.software.enable "development software";
    };
    windowManager.enable = mkDesktopOption "window manager configuration";
    accounts.enable = mkDesktopOption "desktop user accounts";
    fonts.enable = mkDesktopOption "font configuration";
    services.enable = mkDesktopOption "desktop services";
    syncthing.enable = mkDesktopOption "syncthing settings";
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
