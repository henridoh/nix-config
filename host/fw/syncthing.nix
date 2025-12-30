{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "hd";
    configDir = "/home/hd/.config/syncthing";
  };
}
