{
  config,
  lib,
  pkgs,
  secrets,
  var,
  ...
}:

# We have a minimal `git` user accessible via ssh with a cgit instance on onet
# at https://git.lan/. The `git` user has home at `/git` which is backed up
# using rclone (see `backup.nix`).
# Also, for collaboration, we have a forgejo instance
# at https://git.hdohmen.de/.

let
  gitpath = "/git";
  git-config = pkgs.writeText "git-git-config" ''
    [init]
      defaultBranch = main
  '';
  git-shell-commands = {
    "create" = ''
      #!/bin/sh
      REPO_NAME="$1"
      if [ -z "$REPO_NAME" ]; then
        echo "Usage: $0 <repo-name>"
        exit 1
      fi
      REPO_PATH="${gitpath}/$REPO_NAME.git"
      if [ -d "$REPO_PATH" ]; then
        echo "Repository '$REPO_NAME' already exists."
        exit 1
      fi
      git init --bare "$REPO_PATH"
      echo "Created bare repository: $REPO_PATH"
    '';
  };
  git-shell-commands-dir = pkgs.stdenv.mkDerivation {
    name = "git-shell-commands-dir";
    version = "0.0.1";
    src = null;
    dontUnpack = true;
    buildPhase = "";
    installPhase = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: script: ''
        mkdir -p $out
        cat <<'EOF' > $out/${name}
        ${script}
        EOF
        chmod +x $out/${name}
      '') git-shell-commands
    );
  };
in
{
  programs.git.enable = true;
  users.groups.git = { };
  users.users.git = {
    isSystemUser = true;
    home = gitpath;
    homeMode = "755";
    createHome = true;
    group = "git";
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = var.ssh-keys.hd;
    hashedPassword = "!";
    packages = [ pkgs.git ];
  };

  systemd.tmpfiles.rules = [
    "L+ ${gitpath}/git-shell-commands - - - - ${git-shell-commands-dir}"
    "L+ ${gitpath}/.gitconfig - - - - ${git-config}"
  ];

  services =
    let
      cgit-host = "git.lan";
      fogrejo-cfg = config.services.forgejo;
    in
    {
      nginx = {
        privateVirtualHosts.${cgit-host} = { };
      };
      cgit."git" = {
        group = "git";
        enable = true;
        scanPath = gitpath;
        nginx.virtualHost = cgit-host;
        gitHttpBackend.checkExportOkFiles = false;
      };

      nginx = {
        virtualHosts.${fogrejo-cfg.settings.server.DOMAIN} = {
          forceSSL = true;
          enableACME = true;
          extraConfig = ''
            client_max_body_size 512M;
          '';
          locations."/".proxyPass = "http://localhost:${toString fogrejo-cfg.settings.server.HTTP_PORT}";
        };
      };

      forgejo = {
        enable = true;
        database.type = "postgres";
        lfs.enable = true;
        settings = {
          server = {
            DOMAIN = "git.hdohmen.de";
            ROOT_URL = "https://${fogrejo-cfg.settings.server.DOMAIN}/";
            HTTP_PORT = 3000;
          };
          mailer = {
            ENABLED = true;
            SMTP_ADDR = "roam.hdohmen.de";
            FROM = "noreply@git.hdohmen.de";
            USER = "noreply@git.hdohmen.de";
          };
          service.DISABLE_REGISTRATION = true;
          repository = {
            ENABLE_PUSH_CREATE_USER = true;
            ENABLE_PUSH_CREATE_ORG = true;
          };
        };
        secrets = {
          mailer.PASSWD = config.age.secrets.forgejo-mailer-password.path;
        };
      };
    };

  age.secrets.forgejo-mailer-password = {
    file = secrets.roam."forgejo-mailer-password.age";
    mode = "400";
    owner = "forgejo";
  };
}
