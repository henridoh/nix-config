{
  inputs,
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.desktop;
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
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.users."hd" = lib.mkAliasDefinitions options.home;
      # install to /etc/profiles, not ~/.nix-profile
      home-manager.useUserPackages = true;
      # dont use home.nixpkgs
      home-manager.useGlobalPkgs = true;
    }

  ];

  options = {
    desktop.enable = mkEnableOption "Desktop Configuration";
    home = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "home-manager configuration.";
    };
  };

  config = mkIf cfg.enable {
    desktop = {
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

    home = {
      home.stateVersion = config.system.stateVersion;
      imports = [ ../../mod-hm ];
    };
  };
}
