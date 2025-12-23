{
  var,
  inputs,
  lib,
  config,
  ...
}:
with lib;
{
  options.hd.common.enable = mkOption {
    type = types.bool;
    default = true;
    description = "Common options that are used on every host by default.";
  };

  options.hd.common = {
    locale = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.common.enable;
        description = "Enable locale settings";
      };
    };

    nix = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.common.enable;
        description = "Enable Nix-related configuration";
      };
    };

    security = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.common.enable;
        description = "Enable security-related configuration";
      };
    };

    shell = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.common.enable;
        description = "Enable basic shell utilities";
      };
    };

    users = {
      enable = mkOption {
        type = types.bool;
        default = config.hd.common.enable;
        description = "Enable default user accounts";
      };
    };
  };

  imports = [
    inputs.agenix.nixosModules.default
    ./locale.nix
    ./nix.nix
    ./security.nix
    ./shell.nix
    ./users.nix
  ];

  config = mkIf config.hd.common.enable {
    environment.defaultPackages = [ ];
    networking.extraHosts = var.lan-dns.hostsFile;
  };
}
