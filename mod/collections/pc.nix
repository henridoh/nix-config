{ mod, ... }:
{
  imports = with mod; [
    audio
    boot
    fonts
    gpg
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
