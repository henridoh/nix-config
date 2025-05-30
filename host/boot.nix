{ pkgs, ... }:
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };

    # otherwise /tmp is on disk. This *may* be problematic as nix
    # builds in /tmp but I think my swap is large enough...
    tmp.useTmpfs = true;

    kernelPackages = pkgs.linuxPackages_6_13;
    kernel.sysctl."kernel.sysrq" = 1;

    initrd.systemd.network.wait-online.enable = false;
  };
}
