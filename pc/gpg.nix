{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ seahorse ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };
}
