{ lib, ... }@inp:
let
  files = [
    "lan-dns"
    "ssh-keys"
    "wg"
  ];
  import_file = name: { ${name} = import ./${name}.nix (inp // { inherit var; }); };
  var = lib.foldl' (a: b: a // b) { } (map import_file files);
in
var
