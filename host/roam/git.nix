{ pkgs, var, ... }:
let
  gitpath = "/git";
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
    password = "!";
  };

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
      };
    };
}
