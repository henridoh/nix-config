{ ... }:
{
  networking.hostName = "roam";

  imports = [
    ./hardware-configuration.nix
  ];

  services.openssh.enable = true;

  # ====== DON'T CHANGE ======
  system.stateVersion = "24.11";
}
