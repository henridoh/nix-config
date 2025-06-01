{ pkgs, ... }:
{
  home = {
    home.packages = with pkgs; [
      seahorse
      libsecret
      gnome-keyring
    ];
    programs.gpg = {
      enable = true;
    };
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gtk2;
    };
  };
  services.gnome.gnome-keyring = {
    enable = true;
  };
}
