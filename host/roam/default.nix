{ lib', ... }:
let
  submodules = lib'.walk-dir ./.;
in
{
  networking.hostName = "roam";

  imports = [ submodules.to_mod_without_default ];

  # ====== DON'T CHANGE ======
  system.stateVersion = "24.11";
}
