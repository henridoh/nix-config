# This is a NixOS module, not a home-manager module!
{
  lib,
  inputs,
  config,
  options,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = lib.mkIf config.hd.desktop.enable {
    home-manager = {
      users."hd" = lib.mkAliasDefinitions options.home;
      # install to /etc/profiles, not ~/.nix-profile
      useUserPackages = true;
      # dont use home.nixpkgs
      useGlobalPkgs = true;
    };

    home = {
      imports = [
        ./unison.nix
      ];

      home.stateVersion = config.system.stateVersion;
    };
  };
}
