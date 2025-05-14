{ mod, ... }:
{
  imports = with mod; [
    shell
    users
    locale
    nix-configuration
  ];
}
