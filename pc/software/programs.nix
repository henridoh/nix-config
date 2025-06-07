{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bitwarden
    calibre
    element-desktop
    kitty
    nil
    obsidian
    signal-desktop
    spotify
    vesktop
    vlc
    wireguard-tools
    zotero
    zulip
  ];

  virtualisation = {
    docker.enable = true;
  };

  programs = {
    firefox.enable = true;
    kdeconnect.enable = true;
  };

  home = {
    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird-latest;
      profiles.default = {
        isDefault = true;
        withExternalGnupg = true;
      };
    };
  };

  # Some excludes
  services.xserver.excludePackages = [ pkgs.xterm ];
}
