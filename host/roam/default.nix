{ lib', ... }:
{
  networking.hostName = "roam";

  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./security.nix
    ./services.nix
  ];

  # ====== DON'T CHANGE ======
  system.stateVersion = "24.11";
}
