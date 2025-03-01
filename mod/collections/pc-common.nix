{ mod, ... }: {
  imports = with mod; [
    audio
    boot
    fonts
    locale
    network
    nix
    security
    services
    shell
    software
    users
    window-manager
  ];
}