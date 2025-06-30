{ ... }:
{
  networking.hostName = "solo";

  imports = [
    ./hardware-configuration.nix
    ./keyboard.nix
    ./nvidia-gpu.nix
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  desktop.enable = true;

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
