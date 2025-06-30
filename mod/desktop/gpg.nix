{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.gpg;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.desktop.gpg.enable = mkEnableOption "GPG";
  config = mkIf cfg.enable {
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
  };
}
