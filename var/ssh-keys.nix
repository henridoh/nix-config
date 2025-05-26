_: rec {
  # this is only used for forcing password entry on colmena apply
  priviliged-by-host = {
    "solo" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsl8pLaGeCL3kacGWf8pzoLQr501ga/2OzvI2wWbTZJ";
  };
  priviliged = builtins.attrValues priviliged-by-host;

  unprivileged-by-host = {
    "solo" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG+dd4m98aKEWfFa/7VZUlJNX0axvIlHVihT8w7RLyY";
    "c2" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIsoj2+esEebRwDV2PuNRt9Vz28oolOy+Hc2THwrWTAB";
  };
  unprivileged = builtins.attrValues unprivileged-by-host;
}
