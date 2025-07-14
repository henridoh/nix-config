{ lib', ... }:
{
  networking.hostName = "roam";

  age.identityPaths = [
    "/root/.ssh/id_ed25519"
  ];

  imports = [
    ./backup.nix
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
