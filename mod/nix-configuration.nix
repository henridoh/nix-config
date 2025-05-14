{
  lib,
  inputs,
  config,
  ...
}:
{
  config = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
      ];
      auto-optimise-store = true;
    };

    nixpkgs.config.allowUnfree = false;
  };
}
