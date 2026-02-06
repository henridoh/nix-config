{ pkgs, ... }:
{
  networking.hostName = "test-vm";
  services.syncthing.enable = false;
  hd.common.users.enable = false; # default user depends on age

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
      password = "";
    };
    users.root.hashedPassword = "!";
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };

    kernelPackages = pkgs.linuxPackages_6_12;
    initrd.systemd.network.wait-online.enable = false;
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "24.11";
}
