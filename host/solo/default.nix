{ mod, ... }:
{
  networking.hostName = "solo";

  services.xserver.enable = true;

  imports = with mod; [
    collections.pc
    software.keyboard
    software.games
    nvidia-gpu
    ./hardware-configuration.nix
  ];

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
