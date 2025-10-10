{ var, inputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
    ../mod
    ../desktop
    ./locale.nix
    ./nix.nix
    ./security.nix
    ./shell.nix
    ./users.nix
  ];

  environment.defaultPackages = [ ];
  networking.extraHosts = var.lan-dns.hostsFile;
}
