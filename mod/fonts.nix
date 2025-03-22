{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.noto
  ];
  fonts.fontDir.enable = true;
  fonts.fontconfig.defaultFonts.monospace = [ "Noto Nerd Font Mono" ];
}
