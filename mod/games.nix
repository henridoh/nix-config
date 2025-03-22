{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    runelite
  ];

  programs.steam.enable = true;
}
