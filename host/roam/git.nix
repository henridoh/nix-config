{ pkgs, var, ... }:
{
  programs.git.enable = true;
  users.groups.git = { };
  users.users.git = {
    isSystemUser = true;
    home = "/git";
    createHome = true;
    group = "git";
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = var.ssh-keys.hd;
  };
}
