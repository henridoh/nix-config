{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hd.desktop.gpg;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    home = {
      home.packages = with pkgs; [
        libsecret
        gnome-keyring
      ];
      programs.gpg = {
        enable = true;
        publicKeys = [
          {
            source = ../../pgp/id-priv.pgp;
            trust = 5;
          }
          {
            source = ../../pgp/id-uni.pgp;
            trust = 5;
          }
        ];
      };
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentry.package = pkgs.pinentry-gtk2;
      };
    };
  };
}
