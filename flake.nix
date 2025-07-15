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
    flake-utils.url = "github:numtide/flake-utils";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
  };

  outputs =
    {
      self,
      agenix,
      colmena,
      flake-utils,
      home-manager,
      nixos-config-hidden,
      nixos-hardware,
      nixpkgs,
    }@inputs:
    let
      inherit (nixpkgs) lib;
      lib' = import ./lib.nix { inherit lib; };

      specialArgs = rec {
        inherit inputs lib';
        var = import ./var { inherit lib; };
        secrets = lib'.walk-dir ./secrets;
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
            ./home
            ./common
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
            ./home
            ./common
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
            ./common
            overlays
          ];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            colmena.packages.${system}.colmena
            agenix.packages.${system}.default
          ];
        };
        formatter = pkgs.nixfmt-tree;
      }
    );
}
