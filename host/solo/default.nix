{ pkgs, ... }:
{
  networking = {
    hostName = "solo";

    useDHCP = false;
    interfaces.enp4s0.useDHCP = true;

    firewall = {
      enable = true;
    };
  };

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

    kernelPackages = pkgs.linuxPackages_6_12;
    kernel.sysctl."kernel.sysrq" = 1;

    initrd.systemd.network.wait-online.enable = false;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  hd.desktop.enable = true;

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

  environment.systemPackages = with pkgs; [
    prismlauncher
  ];

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
