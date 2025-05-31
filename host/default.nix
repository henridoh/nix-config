{ var, ... }:
{
  imports = [
    ./boot.nix
    ./locale.nix
    ./nix.nix
    ./shell.nix
    ./users.nix
  ];

  networking.extraHosts = var.lan-dns.hostsFile;
}
