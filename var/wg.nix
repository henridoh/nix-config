{ lib, ... }:
rec {
  publicKey = {
    "roam" = "yUbdRfRFFVe4FPUaD7pVByLRhpF9Yl1kethxRUHpVgs=";
    "solo" = "SRDguh0aN/RH8q/uB09w/OZTbP9JZZy0ABowbWIfkTk=";
    "c2" = "yJ1vrI9+qzUHuQJxeRDLCDCMRCIhF+0UNPwz3agyxTk=";
  };
  wireguard-network = {
    "roam" = {
      publicKey = publicKey."roam";
      ips = [ "10.10.11.1/32" ];
      allowedIPs = [ "10.10.11.0/24" ];
      endpoint = "185.163.117.158:51820";
      persistentKeepalive = 17;
    };
    "solo" = {
      publicKey = publicKey."solo";
      ips = [ "10.10.11.2/32" ];
      allowedIPs = [ "10.10.11.2/32" ];
      persistentKeepalive = 13;
    };
    "c2" = {
      publicKey = publicKey."c2";
      ips = [ "10.10.11.3/32" ];
      allowedIPs = [ "10.10.11.3/32" ];
      persistentKeepalive = 19;
    };
  };
  keyFile = "/var/secrets/wg.key";

  peers-for =
    host:
    map (lib.filterAttrs (n: _: n != "ips")) (
      lib.attrValues (lib.filterAttrs (n: _: n != host) wireguard-network)
    );

  ips =
    with builtins;
    mapAttrs (name: value: head (lib.splitString "/" (head value.ips))) wireguard-network;
}
