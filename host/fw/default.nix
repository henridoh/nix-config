{ inputs, ... }:
{
  networking.hostName = "c2";

  age.identityPaths = [
    "/root/.ssh/id_ed25519"
  ];

  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.resumeDevice = "/dev/disk/by-label/nixswap";

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  hd.desktop.enable = true;

  networking.firewall = {
    enable = true;
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
