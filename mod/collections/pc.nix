{ mod, ... }:
{
  imports = with mod; [
    audio
    boot
    fonts
    locale
    network
    nix-configuration
    security
    services
    software.development
    software.programs
    software.shell
    software.window-manager
    users
  ];
}
