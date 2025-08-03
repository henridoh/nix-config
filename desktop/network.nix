{
  config,
  host,
  lib,
  pkgs,
  var,
  ...
}:
let
  cfg = config.hd.desktop.network;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.hd.desktop.network = {
    enable = mkEnableOption "All Network Options";
  };

  config = mkIf cfg.enable {

    hardware.bluetooth.enable = true;
    systemd.network.wait-online.enable = false;

    services = {
      mullvad-vpn.enable = true;
      blueman.enable = true;
      resolved = {
        # TODO: find out why doh breaks moodle...
        enable = true;
      };
    };

    networking = {
      enableIPv6 = true;

      wireguard.enable = true;
      wg-quick = {
        interfaces = {
          "onet" = {
            address = var.wg.wireguard-network.${host}.ips;
            privateKeyFile = var.wg.keyFile;
            peers = [ (lib.removeAttrs var.wg.wireguard-network."roam" [ "ips" ]) ];
            mtu = 1248;
          };
        };
      };

      networkmanager = {
        enable = true;
        plugins = with pkgs; [ networkmanager-openconnect ];
        wifi.macAddress = "random";
        ensureProfiles.profiles = {
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
    };
  };
}
