{ pkgs, ... }:
{
  services = {
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    udisks2.enable = true;
    emacs.enable = true;
  };

  home.services.protonmail-bridge = {
    enable = true;
    path = with pkgs; [
      pass
      gnome-keyring
    ];
  };
}
