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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG+dd4m98aKEWfFa/7VZUlJNX0axvIlHVihT8w7RLyY hd@solo"
      ];
      hashedPassword = "$y$j9T$L7VT26HQSBsX.nq5hKrZw0$6k43wNsKIO.SI.fqE1opaDuNobmFQrGXE1nzFB5wYg3";
    };
    users.root = {
      hashedPassword = "!";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG+dd4m98aKEWfFa/7VZUlJNX0axvIlHVihT8w7RLyY hd@solo"
      ];
    };
  };
}
