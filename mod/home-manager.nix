{
  inputs,
  lib,
  options,
  config,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
    home.home.stateVersion = config.system.stateVersion;
    home-manager.users."hd" = lib.mkAliasDefinitions options.home;
  };

  options = {
    home = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

}
