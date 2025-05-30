{ ... }:
{
  networking.hostName = "solo";

  imports = [
    ./hardware-configuration.nix
    ./keyboard.nix
    ./nvidia-gpu.nix
    ../../pc
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
