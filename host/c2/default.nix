{ inputs, pkgs, ... }:
{
  networking.hostName = "c2";

  age.identityPaths = [
    "/root/.ssh/id_ed25519"
  ];

  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    # common-cpu-intel
    common-pc-laptop
    common-pc-laptop-ssd
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };

    resumeDevice = "/dev/disk/by-label/nixswap";

    kernelPackages = pkgs.linuxPackages_6_12;
    kernel.sysctl."kernel.sysrq" = 1;

    initrd.systemd.network.wait-online.enable = false;
  };

  # Fix for touchpad physical click not working
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
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

  networking.firewall = {
    enable = true;
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
