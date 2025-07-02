{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.security;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.desktop.security.enable = mkEnableOption "Security";
  config = mkIf cfg.enable {
    security.protectKernelImage = true;

    security.sudo.enable = false;
    security.doas = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          persist = true;
          keepEnv = true;
        }
      ];
    };
  };
}
