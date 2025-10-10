{ inputs, ... }:
{
  networking.hostName = "c2";

  age.identityPaths = [
    "/root/.ssh/id_ed25519"
  ];

  imports = [
    ./hardware-configuration.nix
    (inputs.disko.nixosModules.disko ./disko.nix)
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
    };

    initrd.luks.devices.cryptstorage.device = "/dev/disk/by-uuid/TODO";

    kernelPackages = pkgs.linuxPackages_6_12;
    kernel.sysctl."kernel.sysrq" = 1;

    initrd.systemd.network.wait-online.enable = false;
  };

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
