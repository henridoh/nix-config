{ lib', ... }:
{
  networking.hostName = "roam";

  imports = [
    ./git.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./services.nix
  ];

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "acme@henri-dohmen.de";
    };
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "24.11";
}
