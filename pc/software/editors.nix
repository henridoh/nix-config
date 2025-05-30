{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vscode
    emacs
    jetbrains.gateway
    jetbrains.rust-rover
  ];
}
