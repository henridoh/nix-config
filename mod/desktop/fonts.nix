{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.hd.desktop.fonts;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        nerd-fonts.noto
      ];
      fontDir.enable = true;
      fontconfig.defaultFonts.monospace = [ "Noto Nerd Font Mono" ];
    };
  };
}
