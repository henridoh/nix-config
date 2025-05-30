{ pkgs, ... }:
{
  home.services.unison' = {
    enable = true;
    pairs = {
      "docs".roots = [
        "/home/hd/Documents"
        "ssh://roam//home/hd/Documents"
      ];
      "desktop".roots = [
        "/home/hd/Desktop"
        "ssh://roam//home/hd/Desktop"
      ];
    };
  };
}
