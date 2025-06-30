{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.desktop.audio;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.desktop.audio.enable = mkEnableOption "Audio";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pavucontrol
      alsa-utils
    ];

    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
