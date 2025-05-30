{ lib', ... }:
{
  networking.hostName = "roam";

  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./secruity.nix
    ./services.nix
    ./wireguard.nix
  ];

  # ====== DON'T CHANGE ======
  system.stateVersion = "24.11";
}
