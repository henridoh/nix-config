{
  pkgs,
  lib,
  options,
  var,
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
      openssh.authorizedKeys.keys = var.ssh-keys.unprivileged;
      hashedPassword = "$y$jDT$dhvO.xqs8mopz.sFFul.q/$ud5642o7CnVetU6QEu0ctiVMFh7ngZznDf0wp4cXos8";
    };
    users.root = {
      hashedPassword = "!";
      openssh.authorizedKeys.keys = var.ssh-keys.priviliged;
    };
  };
}
