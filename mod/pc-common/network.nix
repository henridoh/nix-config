{ host, var, ... }:
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

    wireguard.enable = true;
    wg-quick = {
      interfaces = {
        "onet" = {
          address = var.wg.wireguard-network.${host}.ips;
          privateKeyFile = var.wg.keyFile;
          peers = var.wg.peers-for host;
        };
        "mullvad" =
          let
            conf = {
              "solo".ips = [
                "10.68.140.249/32"
                "fc00:bbbb:bbbb:bb01::5:8cf8/128"
              ];
              "c2".ips = [
                "10.64.179.105/32"
                "fc00:bbbb:bbbb:bb01::1:b368/128"
              ];
            };
          in
          {
            address = conf.${host}.ips;
            privateKeyFile = var.wg.keyFile;
            peers = [
              {
                allowedIPs = [
                  "0.0.0.0/0"
                  "::0/0"
                ];
                endpoint = "185.213.155.72:51820";
                publicKey = "flq7zR8W5FxouHBuZoTRHY0A0qFEMQZF5uAgV4+sHVw=";
                persistentKeepalive = 23;
              }
            ];
          };
      };
    };

    firewall = {
      allowedUDPPorts = [ 51820 ];
    };

    networkmanager = {
      enable = true;
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
}
