{ lib, ... }:
let
  mkKeys = k: { by-host = k; } // builtins.mapAttrs (_: lib.attrValues) k;
  keys = {
    hd = {
      "solo" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG+dd4m98aKEWfFa/7VZUlJNX0axvIlHVihT8w7RLyY";
      "c2" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIsoj2+esEebRwDV2PuNRt9Vz28oolOy+Hc2THwrWTAB";
      "roam" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEDlh8hY01wwmNtfa1eK3mVBIcytdh4n/kV05gP9z1Lc";
      "fw" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmxhDwylLlklpgiUWHc0BPSCkNkuAIrXLNOHpAcgXiL";
    };
    root = {
      "solo" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsl8pLaGeCL3kacGWf8pzoLQr501ga/2OzvI2wWbTZJ";
      "c2" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAZaswaiA+oQ9NviADYFf7BJQHNlmdxQuocIdoJmv3o";
      "roam" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID++uLcQOx/to3sEo5Nk97CenGf0Y6/dMsBbLouVTgIQ";
      "fw" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOjfPXDS3UvVGXzJYXU8TyP5q0WDzb0anx4Std40AT+j";
    };
  };
  keys' = mkKeys keys;
  mkTrusted =
    user: with keys'.by-host.${user}; [
      solo
      c2
      fw
    ];
in
keys'
// {
  trusted-hd = mkTrusted "hd";
  trusted-root = mkTrusted "root";
}
