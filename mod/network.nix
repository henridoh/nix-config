{ ... }:
{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  networking = {
    enableIPv6 = true;
    networkmanager.enable = true;
    networkmanager.wifi.macAddress = "random";
    networkmanager.ensureProfiles.profiles = {
      "tuda-vpn" = {
        connection = {
          autoconnect = "false";
          id = "tuda-vpn";
          type = "vpn";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "stable-privacy";
          method = "auto";
        };
        vpn = {
          authtype = "password";
          autoconnect-flags = "0";
          certsigs-flags = "0";
          cookie-flags = "2";
          disable_udp = "no";
          enable_csd_trojan = "no";
          gateway = "vpn.hrz.tu-darmstadt.de";
          gateway-flags = "2";
          gwcert-flags = "2";
          lasthost-flags = "0";
          pem_passphrase_fsid = "no";
          prevent_invalid_cert = "no";
          protocol = "anyconnect";
          resolve-flags = "2";
          service-type = "org.freedesktop.NetworkManager.openconnect";
          stoken_source = "disabled";
          xmlconfig-flags = "0";
          password-flags = 0;
        };
      };
    };
  };
}
