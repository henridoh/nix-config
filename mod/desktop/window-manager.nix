{
  config,
  lib,
  ...
}:
let
  cfg = config.hd.desktop.windowManager;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.desktopManager.plasma6.enable = true;
  };
}
