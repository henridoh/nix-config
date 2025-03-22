{ mod, ... }:
{
  networking.hostName = "c2";

  imports = with mod; [
    collections.pc-common
    ./hardware-configuration.nix
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # ====== DON'T CHANGE ======
  system.stateVersion = "25.05";
}
