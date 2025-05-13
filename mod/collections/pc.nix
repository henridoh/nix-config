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
    shell
    software.development
    software.editors
    software.programs
    software.window-manager
    users
  ];
}
