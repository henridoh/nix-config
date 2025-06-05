{
  lib,
  options,
  config,
  ...
}:
with lib;
{
  options.services.nginx.virtualHostsPub = mkOption {
    type = options.services.nginx.virtualHosts.type;
    default = { };
    description = "Declarative vhost config listening to ::0 and 0.0.0.0";
  };

  config = {
    services.nginx.virtualHosts = builtins.mapAttrs (
      _: v:
      v
      // {
        addSSL = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "[::0]";
            port = 443;
            ssl = true;
          }
          {
            addr = "[::0]";
            port = 80;
          }
        ];
      }
    ) config.services.nginx.virtualHostsPub;
  };
}
