{ inputs, system }:
let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
{
  supernote-tool = pkgs.callPackage ./supernote-tool.nix { };
}
