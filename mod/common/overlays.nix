{ inputs, ... }:
{
  nixpkgs.overlays = with inputs; [
    vscode-extensions.overlays.default
    colmena.overlay
  ];
}
