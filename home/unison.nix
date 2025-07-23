{ lib, config, ... }:
let
  cfg = config.services.unison';
in
{
  options.services.unison' = {
    enable = lib.mkEnableOption "Unison file synchronizer";
    pairs = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf (lib.types.listOf lib.types.str));
      default = { };
      description = "";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = lib.mapAttrs' (name: roots: {
      name = ".unison/${name}.prf";
      value.text = ''
        watch = true
        auto = true
        batch = true
        sshargs = -C
        logfile = /dev/null
        confirmbigdeletes = true
        confirmmerge = true
      ''
      + lib.concatStringsSep "\n" (map (root: "root = ${root}") roots.roots);
    }) cfg.pairs;
  };
}
