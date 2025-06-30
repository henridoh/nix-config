{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.desktop.software.development;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.desktop.software.development.enable = mkEnableOption "Dev Software";

  config = mkIf cfg.enable {
    documentation.dev.enable = true;

    environment.systemPackages = with pkgs; [
      vscode
      binutils
      clang
      gcc
      gdb
      gnumake
      man-pages
      man-pages-posix
      nixfmt-rfc-style
      python313
      python313Packages.mypy
      rustup
      emacs
      jetbrains.gateway
      jetbrains.rust-rover
    ];
  };
}
