{
  inputs,
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.hd.desktop;
  inherit (lib) mkEnableOption mkIf;
in
{
  imports = [
    ./accounts.nix
    ./audio.nix
    ./fonts.nix
    ./gpg.nix
    ./network.nix
    ./security.nix
    ./services.nix
    ./software
    ./window-manager.nix
  ];

  options = {
    hd.desktop.enable = mkEnableOption "Desktop Configuration";
    home = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "home-manager configuration.";
    };
  };

  config = mkIf cfg.enable {
    hd.desktop = {
      accounts.enable = lib.mkDefault true;
      audio.enable = lib.mkDefault true;
      fonts.enable = lib.mkDefault true;
      gpg.enable = lib.mkDefault true;
      network.enable = lib.mkDefault true;
      security.enable = lib.mkDefault true;
      services.enable = lib.mkDefault true;
      software.enable = lib.mkDefault true;
      wm.enable = lib.mkDefault true;
    };

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
      ];

    programs.nix-ld.enable = true;
  };
}
