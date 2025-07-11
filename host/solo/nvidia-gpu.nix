{ config, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false; # TODO: switch to open driver if it works again

    nvidiaSettings = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
  };

  boot.kernelParams = [
    "nvidia-drm.fbdev=1"
    "nvidia-drm.modeset=1"
  ];
}
