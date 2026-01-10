{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  networking.hostName = "fw";
  hd = {
    desktop.enable = true;
    buildMachines.enable = true;
  };

  age.identityPaths = [
    "/root/.ssh/id_ed25519"
  ];

  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    inputs.lanzaboote.nixosModules.lanzaboote
    ./disko.nix
    ./hardware-configuration.nix
    ./syncthing.nix
  ];

  # https://github.com/NixOS/nixos-hardware/issues/1603
  services.pipewire.wireplumber.extraConfig.no-ucm = {
    "monitor.alsa.properties" = {
      "alsa.use-ucm" = false;
    };
  };

  # BIOS updated
  services.fwupd.enable = true;

  environment.systemPackages = [
    pkgs.sbctl
  ];

  services.fprintd.enable = true;

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_6_18;
    kernel.sysctl."kernel.sysrq" = 1;
    initrd.systemd.network.wait-online.enable = false;
    # Should fix infrequent GPU crashes
    # https://github.com/ROCm/ROCm/issues/5590
    kernelParams = [ "amdgpu.cwsr_enable=0" ];
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
