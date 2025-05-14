{ mod, ... }:
{
  imports = with mod.server; [
    services
    networking
    security
  ];
}
