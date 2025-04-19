{
  pkgs,
  lib,
  options,
  ...
}:
{
  users.users."hd" = {
    description = "Henri";
    isNormalUser = true;
    createHome = true;
    home = "/home/hd";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = [ ];
  };

  home-manager.users."hd" = lib.mkAliasDefinitions options.home;
  users.users.root.hashedPassword = "!";
}
