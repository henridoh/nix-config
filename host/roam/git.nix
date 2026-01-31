{
  pkgs,
  var,
  lib,
  ...
}:
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
    };
}
