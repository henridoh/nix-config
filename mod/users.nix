{
  pkgs,
  lib,
  options,
  ...
}:
{
  users = {
    mutableUsers = false;
    users."hd" = {
      description = "Henri";
      isNormalUser = true;
      createHome = true;
      home = "/home/hd";
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
      packages = [ ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG+dd4m98aKEWfFa/7VZUlJNX0axvIlHVihT8w7RLyY"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIsoj2+esEebRwDV2PuNRt9Vz28oolOy+Hc2THwrWTAB"
      ];
      hashedPassword = "$y$jDT$dhvO.xqs8mopz.sFFul.q/$ud5642o7CnVetU6QEu0ctiVMFh7ngZznDf0wp4cXos8";
    };
    users.root = {
      hashedPassword = "!";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG+dd4m98aKEWfFa/7VZUlJNX0axvIlHVihT8w7RLyY"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIsoj2+esEebRwDV2PuNRt9Vz28oolOy+Hc2THwrWTAB"
      ];
    };
  };
}
