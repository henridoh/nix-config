{
  lib,
  inputs,
  config,
  ...
}:
{
  config = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
    };

    programs.nix-ld.enable = true;

    nixpkgs.config.allowUnfree = false;
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

    home.home.stateVersion = config.system.stateVersion; # is this safe?
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # I don't think this will ever be multi user,
  # no need to seperate home-manager. `home` is used
  # in users.nix, I should prbably refactor...
  options = {
    home = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
