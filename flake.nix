{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    colmena.url = "github:zhaofengli/colmena";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      colmena,
      home-manager,
    }@inputs:
    let
      lib = nixpkgs.lib;
      lib' = import ./lib.nix { inherit lib; };
      mod = lib'.walk-dir ./mod;
      specialArgs = { inherit inputs lib' mod; };
    in
    {
      nixosConfigurations = {
        "solo" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit specialArgs;
          modules = [
            ./host/solo
            mod.shared.pc
          ];
        };

        "c2" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit specialArgs;
          modules = [
            ./host/c2
            mod.shared.pc
          ];
        };
      };

      colmenaHive = colmena.lib.makeHive {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
          };
          inherit specialArgs;
        };
        "roam" = {
          deployment = {
            targetHost = "185.163.117.158";
            buildOnTarget = true;
          };
          imports = [
            ./host/roam
            mod.shared.all
          ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
