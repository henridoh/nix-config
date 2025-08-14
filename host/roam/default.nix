_: {
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
  ];

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "acme@henri-dohmen.de";
    };
  };

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

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "24.11";
}
