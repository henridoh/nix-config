{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hd.desktop.security;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.hd.desktop.security.enable = mkEnableOption "Security";
  config = mkIf cfg.enable {
    security = { };
  };
}
