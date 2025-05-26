{ lib', ... }:
let
  submodules = lib'.walk-dir ./.;
in
{
  networking.hostName = "solo";

  imports = [ submodules.to_mod_without_default ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
