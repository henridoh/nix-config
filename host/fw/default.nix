{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  networking.hostName = "fw";

  age.identityPaths = [
    "/root/.ssh/id_ed25519"
  ];

  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    inputs.lanzaboote.nixosModules.lanzaboote
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
  # security.pam.enableFscrypt = true;

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
      # grub = {
      #   enable = false;
      #   efiSupport = true;
      # };
    };

    kernelPackages = pkgs.linuxPackages_6_12;
    kernel.sysctl."kernel.sysrq" = 1;

    initrd.systemd.network.wait-online.enable = false;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  nix = {
    buildMachines = [
      {
        hostName = "noravm";
        sshUser = "nixremote";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        maxJobs = 32;
        speedFactor = 2;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        mandatoryFeatures = [ ];
      }
    ];
    distributedBuilds = true;
    extraOptions = ''
      	  builders-use-substitutes = true
      	'';
  };

  hd.desktop.enable = true;

  networking = {
    useDHCP = lib.mkDefault true;
    firewall.enable = true;
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
