{ lib, ... }: {
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "@wheel" ];
    auto-optimise-store = true;
  };
  
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = false;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
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

  # TODO this is for zulip 5.11.1
  nixpkgs.config.permittedInsecurePackages = [
    "electron-32.3.3"
  ];
}