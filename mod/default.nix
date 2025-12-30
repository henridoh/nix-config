{ ... }:
{
  imports = [
    ./build-machines.nix
    ./common
    ./desktop
    ./nginx.nix
    ./syncthing.nix
  ];
}
