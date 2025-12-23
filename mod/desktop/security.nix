{
  config,
  lib,
  ...
}:
let
  cfg = config.hd.desktop.security;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    security.pam = {
      services.login.enableGnomeKeyring = true;
    };
    services = {
      gnome.gnome-keyring.enable = true;
    };
    programs.seahorse.enable = true;
  };
}
