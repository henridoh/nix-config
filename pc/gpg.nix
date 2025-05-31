{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    seahorse
    libsecret
  ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };
  services.gnome.gnome-keyring = {
    enable = true;
  };
}
