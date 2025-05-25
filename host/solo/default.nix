{ lib', ... }:
{
  networking.hostName = "solo";

  imports = lib'.import-recursive ./.;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
