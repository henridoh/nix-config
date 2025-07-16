{
  lib,
  options,
  config,
  var,
  ...
}:
with lib;
{
  options.services.nginx.virtualHostsPriv = mkOption {
    type = options.services.nginx.virtualHosts.type;
    default = { };
    description = "Declarative vhost config listening on onet";
  };

  config = {
    services.nginx.virtualHosts = builtins.mapAttrs (
      _: v:
      v
      // {
        listen = [
          {
            addr = var.wg.ips.roam;
            port = 80;
          }
          /*
            { TODO: Fix certs
              addr = var.wg.ips.roam;
              port = 443;
              ssl = true;
            }
          */
        ];
      }
    ) config.services.nginx.virtualHostsPriv;
  };
}
