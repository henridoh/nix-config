{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    signal-desktop
    element-desktop
    zulip
    vesktop
    wireguard-tools
    bitwarden
    kitty
    nil
    vlc
    spotify
    calibre
    zotero
    obsidian
  ];

  virtualisation = {
    docker.enable = true;
  };

  programs = {
    firefox.enable = true;
  };

  home = {
    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird-latest;
      profiles.default = {
        isDefault = true;
        settings = {
          "mail.openpgp.allow_external_gnupg" = true;
          "mail.openpgp.fetch_pubkeys_from_gnupg" = true;
        };
      };
    };
  };

  # Some excludes
  services.xserver.excludePackages = [ pkgs.xterm ];
}
