{
  var,
  inputs,
  lib,
  config,
  ...
}:
with lib;
let
  mkCommonOption =
    name:
    mkOption {
      type = types.bool;
      default = config.hd.common.enable;
      description = "Enables" ++ name;
    };
in
{
  options.hd.common.enable = mkOption {
    type = types.bool;
    default = true;
    description = "Common options that are used on every host by default.";
  };

  options.hd.common = {
    locale.enable = mkCommonOption "locale settings";
    nix.enable = mkCommonOption "nix settings";
    security.enable = mkCommonOption "security settings";
    shell.enable = mkCommonOption "shell utilities";
    users.enable = mkCommonOption "default users";
    secrets.enable = mkCommonOption "agenix secrets";
  };

  imports = [
    inputs.agenix.nixosModules.default
    ./locale.nix
    ./nix.nix
    ./overlays.nix
    ./security.nix
    ./shell.nix
    ./users.nix
  ];

  config = mkIf config.hd.common.enable {
    environment.defaultPackages = [ ];
    networking.extraHosts = var.lan-dns.hostsFile;
  };
}
