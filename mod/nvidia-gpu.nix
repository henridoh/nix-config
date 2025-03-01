{ config, ... }: {
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    modesetting.enable = true;
    nvidiaSettings = true;

    open = false;
    powerManagement = {
      enable = true;
      finegrained = false;
    };    
  };

  boot.kernelParams = [
    "nvidia-drm.fbdev=1"
    "nvidia-drm.modeset=1"
  ];
}
