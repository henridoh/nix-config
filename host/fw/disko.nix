let
  root = {
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

  swap = {
    size = "48G";
    content = {
      extraArgs = [ "-L nixswap" ];
      type = "swap";
      resumeDevice = true;
    };
  };
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vdb";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
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
              content = {
                type = "luks";
                name = "crypt";
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
        lvs = { inherit root swap; };
      };
    };
  };
}
