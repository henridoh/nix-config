{ mod, inputs, ... }:
{
  networking.hostName = "c2";

  imports =
    with mod;
    [
      collections.pc
      ./hardware-configuration.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-pc-laptop
      common-pc-laptop-ssd
    ]);

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
