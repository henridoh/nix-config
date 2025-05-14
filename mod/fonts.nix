{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.noto
    ];
    fontDir.enable = true;
    fontconfig.defaultFonts.monospace = [ "Noto Nerd Font Mono" ];
  };
}
