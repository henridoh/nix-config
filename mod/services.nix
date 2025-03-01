{ ... }: {
  systemd.services.NetworkManager-wait-online.enable = false;
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}