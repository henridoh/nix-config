{ pkgs, ... }:
{

  environment.systemPackages =
    let
      editors = with pkgs; [
        vscode
        emacs
        jetbrains.gateway
        jetbrains.rust-rover
      ];

      messengers = with pkgs; [
        signal-desktop
        element-desktop
        zulip
        vesktop
      ];

      util = with pkgs; [
        wireguard-tools
        bitwarden
        kitty
        nil
      ];

      media = with pkgs; [
        vlc
        spotify
        calibre
      ];

      productivity = with pkgs; [
        zotero
        obsidian
      ];

      dev = with pkgs; [
        rustup
        python313
        gcc
        binutils
      ];

    in
    editors ++ messengers ++ util ++ media ++ productivity ++ dev;

  virtualisation = {
    docker.enable = true;
  };

  programs = {
    firefox.enable = true;
    thunderbird = {
      enable = true;
      package = pkgs.thunderbird-latest;
    };
  };

  # Some excludes
  services.xserver.excludePackages = [ pkgs.xterm ];
}
