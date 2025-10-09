let
  rootfs = {
    type = "btrfs";
    extraArgs = [
      "-f"
      "-L"
      "nixroot"
    ];
    subvolumes = {
      "/root" = {
        mountpoint = "/";
        mountOptions = [
          "compress=zstd"
          "noatime"
        ];
      };
      "/home" = {
        mountpoint = "/home";
        mountOptions = [
          "compress=zstd"
          "noatime"
        ];
      };
      "/nix" = {
        mountpoint = "/nix";
        mountOptions = [
          "compress=zstd"
          "noatime"
        ];
      };
    };
  };
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              label = "boot";
              name = "BOOT";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              label = "crypt";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = {
                  keyFile = "/tmp/secret.key";
                  allowDiscards = true;
                };
                additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%";
            content = rootfs;
          };
          swap = {
            size = "48G";
            content = {
              extraArgs = [ "-L nixswap" ];
              type = "swap";
              resumeDevice = true;
            };
          };

        };
      };
    };
  };
}
