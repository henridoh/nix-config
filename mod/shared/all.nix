{ mod, ... }:
{
  imports = with mod; [
    boot
    locale
    nix-configuration
    shell
    users
  ];
}
