{ var, inputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
    ../mod
    ../desktop
    ./boot.nix
    ./locale.nix
    ./nix.nix
    ./security.nix
    ./shell.nix
    ./users.nix
  ];

  environment.defaultPackages = [ ];
  networking.extraHosts = var.lan-dns.hostsFile;
}
