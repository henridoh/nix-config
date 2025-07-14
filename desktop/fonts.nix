{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.hd.desktop.fonts;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.hd.desktop.fonts.enable = mkEnableOption "Fonts";
  config = mkIf cfg.enable {
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
  };
}
