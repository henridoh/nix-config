{ lib, ... }:
{
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
