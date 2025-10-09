{ config, lib, ... }:
let
  cfg = config.hd.desktop.accounts;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.hd.desktop.accounts.enable = mkEnableOption "Accounts";
  config = mkIf cfg.enable {
    home = {
      accounts.email.accounts = {
        "Posteo" = rec {
          primary = true;
          address = "henridohmen@posteo.com";
          realName = "Henri Dohmen";
          smtp = {
            tls.enable = true;
            host = "posteo.de";
            port = 465;
          };
          imap = {
            tls.enable = true;
            host = "posteo.de";
            port = 993;
          };
          userName = address;
          thunderbird.enable = true;
          gpg.key = "AB79213B044674AE";
        };

        "Uni" = {
          address = "henri.dohmen@stud.tu-darmstadt.de";
          realName = "Henri Dohmen";
          smtp = {
            tls.enable = true;
            host = "smtp.tu-darmstadt.de";
            port = 465;
          };
          imap = {
            tls.enable = true;
            host = "imap.stud.tu-darmstadt.de";
            port = 993;
          };
          userName = "hd48xebi";
          thunderbird.enable = true;
          gpg.key = "24FCE000F3470BAC";
        };

        "Proton" = rec {
          address = "dohmenhenri@proton.me";
          realName = "Henri Dohmen";
          smtp = {
            tls.enable = true;
            tls.useStartTls = true;
            host = "127.0.0.1";
            port = 1025;
          };
          imap = {
            tls.enable = true;
            tls.useStartTls = true;
            host = "127.0.0.1";
            port = 1143;
          };
          userName = address;
          thunderbird.enable = true;
          gpg.key = "AB79213B044674AE";
        };
      };
      accounts.calendar.accounts = {
        "Privat" = {
          primary = true;
          thunderbird = {
            enable = true;
          };
          remote = {
            type = "caldav";
            url = "https://posteo.de:8443/calendars/henridohmen/default";
            userName = "henridohmen@posteo.com";
          };
        };
        "Uni" = {
          thunderbird = {
            enable = true;
          };
          remote = {
            type = "caldav";
            url = "https://posteo.de:8443/calendars/henridohmen/zqrobi";
            userName = "henridohmen@posteo.com";
          };
        };
      };
      accounts.contact.accounts = {
        "Kontakte" = {
          thunderbird = {
            enable = true;
          };
          remote = {
            type = "carddav";
            url = "https://posteo.de:8843/addressbooks/henridohmen/default/";
            userName = "henridohmen";
          };
        };
      };
    };
  };
}
