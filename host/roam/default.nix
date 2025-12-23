{ pkgs, ... }:
{
  networking.hostName = "roam";

  age.identityPaths = [
    "/root/.ssh/id_ed25519"
  ];

  imports = [
    ./backup.nix
    ./firefox-sync.nix
    ./git.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./services.nix
    ./syncthing.nix
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };

    kernelPackages = pkgs.linuxPackages_6_12;
    initrd.systemd.network.wait-online.enable = false;
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "acme@henri-dohmen.de";
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "24.11";
}
