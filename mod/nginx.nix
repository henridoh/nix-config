{
  lib,
  options,
  config,
  var,
  secrets,
  ...
}:
with lib;
{
  options.services.nginx.privateVirtualHosts = mkOption {
    type = options.services.nginx.virtualHosts.type;
    default = { };
    description = "Declarative vhost config listening on onet";
  };

  config = mkIf (config.services.nginx.privateVirtualHosts != { }) {
    age.secrets.tlskey = {
      file = secrets."tlskey.age";
      mode = "440";
      owner = config.services.nginx.user;
      group = config.services.nginx.group;
    };

    services.nginx.virtualHosts = builtins.mapAttrs (
      _: v:
      v
      // {
        sslCertificateKey = config.age.secrets.tlskey.path;
        sslCertificate = ../pki/server.cert;

        addSSL = true;
        listen = [
          {
            addr = var.wg.ips.roam;
            port = 80;
          }
          {
            addr = var.wg.ips.roam;
            port = 443;
            ssl = true;
          }
        ];
      }
    ) config.services.nginx.privateVirtualHosts;
  };
}
