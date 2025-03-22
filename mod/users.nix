{ pkgs, ... }:
{
  users.users.hd = {
    description = "Henri";
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = [ ];
  };
}
