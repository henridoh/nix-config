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
    ./audio.nix
    ./fonts.nix
    ./gpg.nix
    ./network.nix
    ./security.nix
    ./services.nix
    ./software
    ./window-manager.nix
    inputs.nixos-config-hidden.nixosModules.pc
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
      audio.enable = true;
      fonts.enable = true;
      gpg.enable = true;
      network.enable = true;
      security.enable = true;
      services.enable = true;
      software.enable = true;
      wm.enable = true;
    };

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
        "vscode"
        "obsidian"
        "steam"
        "steam-unwrapped"
        "gateway" # jetbrains
        "spotify"
        "rust-rover"
      ];

    programs.nix-ld.enable = true;
  };
}
