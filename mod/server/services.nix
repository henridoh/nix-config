{ config, ... }:
let
  headscale-domain = "headscale.hdohmen.de";
in
{
  services = {
    # TODO: maybe just use wireguard...
    headscale = {
      enable = true;
      address = "127.0.0.1";
      port = 8080;
      settings = {
        server_url = "https://${headscale-domain}";
        prefixes.v4 = "100.10.11.0/24";
        prefixes.v6 = "fd7a:115c:1011::/48";
        dns = {
          magic_dns = true;
          base_domain = "net.hdohmen.de";
        };
      };
    };

    nginx = {
      enable = true;
      virtualHosts.${headscale-domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
