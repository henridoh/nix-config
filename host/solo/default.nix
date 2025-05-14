{ mod, ... }:
{
  networking.hostName = "solo";

  imports = with mod; [
    software.keyboard
    nvidia-gpu
    ./hardware-configuration.nix
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
