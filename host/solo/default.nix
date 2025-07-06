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

  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
