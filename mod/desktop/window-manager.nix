{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.desktop.wm;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.desktop.wm.enable = mkEnableOption "Window Manager";

  config = mkIf cfg.enable {
    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.desktopManager.plasma6.enable = true;
  };
}
