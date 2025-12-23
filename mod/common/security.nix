{
  config,
  lib,
  ...
}:
with lib;
{
  config = mkIf config.hd.common.security.enable {
    boot = {
      kernel.sysctl = {
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;

        "net.ipv4.conf.all.accept_source_route" = 0;
        "net.ipv6.conf.all.accept_source_route" = 0;
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.default.send_redirects" = 0;
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.secure_redirects" = 0;
        "net.ipv4.conf.default.secure_redirects" = 0;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;

        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.tcp_rfc1337" = 1;

        "net.ipv4.tcp_fastopen" = 3;

        "kernel.kptr_restrict" = 2;
        "randomize_kstack_offset" = "on";
        "spec_store_bypass_disable" = "on";
      };
      # otherwise /tmp is on disk. This *may* be problematic as nix
      # builds in /tmp but I think my swap is large enough...
      tmp.useTmpfs = lib.mkDefault true;
      tmp.cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);

      kernelParams = [
        "init_on_free=1" # zero freed pages
        "page_alloc.shuffle=1"
        "page_poison=1"
        "slab_nomerge"
        # "slub_debug=FZ" # disabled due to https://lore.kernel.org/all/20210601182202.3011020-5-swboyd@chromium.org/T/#u
        "vsyscall=none" # diable virtual syscalls
      ];

      blacklistedKernelModules = [
        "ax25"
        "netrom"
        "rose"
        "adfs"
        "affs"
        "bfs"
        "befs"
        "cramfs"
        "efs"
        "erofs"
        "exofs"
        "freevxfs"
        "f2fs"
        "hfs"
        "hpfs"
        "jfs"
        "minix"
        "nilfs2"
        "ntfs"
        "omfs"
        "qnx4"
        "qnx6"
        "sysv"
        "ufs"
      ];
    };

    networking.firewall.enable = true;

    security = {
      protectKernelImage = true;
      forcePageTableIsolation = true;

      apparmor.enable = true;
      apparmor.killUnconfinedConfinables = true;

      sudo.enable = false;

      doas = {
        enable = true;
        extraRules = [
          {
            groups = [ "wheel" ];
            persist = true;
            keepEnv = true;
          }
        ];
      };

      pki.certificateFiles = [ ../../pki/ca.cert ];
    };
  };
}
