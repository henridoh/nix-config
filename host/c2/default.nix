{ inputs, ... }:
{
  networking.hostName = "c2";

  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    common-cpu-intel
    common-pc-laptop
    common-pc-laptop-ssd
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.resumeDevice = "/dev/disk/by-label/nixswap";

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
        maxJobs = 10;
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
