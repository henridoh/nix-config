{ lib', ... }:
{
  networking.hostName = "roam";

  imports = lib'.import-recursive ./.;

  # ====== DON'T CHANGE ======
  system.stateVersion = "24.11";
}
