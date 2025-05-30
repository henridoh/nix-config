{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    colmena.url = "github:zhaofengli/colmena";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-config-hidden = {
      url = "git+ssh://git@github.com/henridoh/nixos-config-hidden";
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
      nixos-config-hidden,
    }@inputs:
    let
      lib = nixpkgs.lib;
      lib' = import ./lib.nix { inherit lib; };

      specialArgs = {
        inherit inputs lib';
        var = (lib'.walk-dir ./var).map_import_with_lib;
      };
      overlays = _: {
        nixpkgs.overlays = [ colmena.overlay ];
      };
    in
    {
      nixosConfigurations = {
        "solo" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = specialArgs // {
            host = "solo";
          };
          modules = [
            ./host/solo
            ./host
            ./mod
            overlays
          ];
        };

        "c2" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = specialArgs // {
            host = "c2";
          };
          modules = [
            ./host/c2
            ./host
            ./mod
            overlays
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
            ./host
            ./mod
            overlays
          ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
