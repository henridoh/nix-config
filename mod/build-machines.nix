{ lib, config, ... }:
with lib;
{
  options.hd.buildMachines.enable = mkEnableOption "Use standard remote builders";
  config = mkIf config.hd.buildMachines.enable {
    nix = {
      buildMachines = [
        {
          hostName = "noravm"; # TODO: do not rely on mutable ssh config
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
  };
}
