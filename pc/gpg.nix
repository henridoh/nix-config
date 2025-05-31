{ pkgs, ... }:
{
  home = {
    home.packages = with pkgs; [
      seahorse
      libsecret
    ];
    programs.gpg = {
      enable = true;
    };
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gtk2;
    };
    services.gnome-keyring = {
      enable = true;
    };
  };
}
