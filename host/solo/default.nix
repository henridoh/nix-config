{ pkgs, ... }:
{
  networking = {
    hostName = "solo";
    useDHCP = false;
    interfaces.enp4s0.useDHCP = true;
  };
  hd.desktop.enable = true;

  age.identityPaths = [
    "/root/.ssh/id_ed25519"
  ];

  imports = [
    ./hardware-configuration.nix
    ./keyboard.nix
    ./nvidia-gpu.nix
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
    kernelPackages = pkgs.linuxPackages_6_18;
    kernel.sysctl."kernel.sysrq" = 1;
    initrd.systemd.network.wait-online.enable = false;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  environment.systemPackages = with pkgs; [
    prismlauncher
  ];

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
