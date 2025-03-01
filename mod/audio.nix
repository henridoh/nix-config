{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    pavucontrol
    alsa-utils
  ];
  
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}