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
    home-manager.users."hd" = lib.mkAliasDefinitions options.home;
    # install to /etc/profiles, not ~/.nix-profile
    home-manager.useUserPackages = true;
    # dont use home.nixpkgs
    home-manager.useGlobalPkgs = true;

    home = {
      imports = [
        ./unison.nix
        ./protonmail-bridge.nix
      ];

      home.stateVersion = config.system.stateVersion;
    };
  };
}
