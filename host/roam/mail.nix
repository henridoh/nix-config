{ inputs, config, ... }:
{
  imports = [ inputs.simple-nixos-mailserver.nixosModule ];

  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "roam.hdohmen.de";
    x509.useACMEHost = config.mailserver.fqdn;
    domains = [ "hdohmen.de" ];
    loginAccounts = {
      "hd@hdohmen.de" = {
        hashedPassword = "$y$j9T$ThusPQJOPsUxfJrO6T6kN/$4hoobYwjhxSLo.f8uWg7DZu7gHtRlUt.nfiDC5xN2w2";
        aliases = [ "hd@hdohmen.de" ];
      };
    };
  };
}
