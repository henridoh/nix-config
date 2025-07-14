{ ... }:
{
  networking = {
    hostName = "solo";

    useDHCP = false;
    interfaces.enp4s0.useDHCP = true;

    firewall = {
      enable = true;
    };
  };

  age.identityPaths = [
    "/root/.ssh/id_ed25519"
  ];

  imports = [
    ./hardware-configuration.nix
    ./keyboard.nix
    ./nvidia-gpu.nix
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  hd.desktop.enable = true;

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
