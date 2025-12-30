{
  config,
  lib,
  pkgs,
  secrets,
  var,
  ...
}:
with lib;
{
  config = mkIf config.hd.common.users.enable {
    age.secrets.hd-password = {
      file = secrets."hd-password.age";
    };

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
        openssh.authorizedKeys.keys = var.ssh-keys.trusted-hd;
        hashedPasswordFile = config.age.secrets.hd-password.path;
      };
      users.root = {
        hashedPassword = "!";
        openssh.authorizedKeys.keys = var.ssh-keys.root;
      };
    };
  };
}
