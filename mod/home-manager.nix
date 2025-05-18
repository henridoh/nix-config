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
    {
      home-manager.users."hd" = lib.mkAliasDefinitions options.home;
      # install to /etc/profiles, not ~/.nix-profile
      home-manager.useUserPackages = true;
      # dont use home.nixpkgs
      home-manager.useGlobalPkgs = true;
    }
  ];

  config = {
    home.home.stateVersion = config.system.stateVersion;
  };

  options = {
    home = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
