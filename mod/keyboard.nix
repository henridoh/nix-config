{ pkgs, ... }: {
  # hardware.keyboard.qmk.enable = true;
  environment.systemPackages = with pkgs; [ vial ];
  services.udev.packages = with pkgs; [ vial ];
}
