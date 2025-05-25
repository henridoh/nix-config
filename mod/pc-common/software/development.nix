{ pkgs, ... }:
{
  documentation.dev.enable = true;

  environment.systemPackages = with pkgs; [
    rustup
    python313
    python313Packages.mypy
    gcc
    clang
    gdb
    gnumake
    binutils
    nixfmt-rfc-style
    man-pages
    man-pages-posix
  ];
}
