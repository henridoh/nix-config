{
  lib,
  inputs,
  config,
  ...
}:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "root" ];
    auto-optimise-store = true;
  };
  nix.registry = {
    hd.flake = inputs.self;
    nixpkgs.flake = inputs.nixpkgs;
  };
  nixpkgs.config.allowUnfree = false;
}
