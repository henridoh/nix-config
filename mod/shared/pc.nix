{ mod, lib, ... }:
{
  imports = with mod; [
    shared.all

    audio
    fonts
    gpg
    home-manager
    network
    nix-configuration
    security
    services
    software.development
    software.editors
    software.programs
    software.window-manager
  ];

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

}
