{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
    vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      agenix,
      colmena,
      disko,
      flake-utils,
      home-manager,
      lanzaboote,
      nixos-hardware,
      nixpkgs-stable,
      nixpkgs,
      vscode-extensions,
    }@inputs:
    let
      inherit (nixpkgs) lib;
      lib' = import ./lib.nix { inherit lib; };
      pkgs-stable = import nixpkgs-stable { system = "x86_64-linux"; };

      specialArgs = rec {
        inherit inputs lib' pkgs-stable;
        var = import ./var { inherit lib; };
        secrets = lib'.walk-dir ./secrets;
      };
      overlays = _: {
        nixpkgs.overlays = [
          vscode-extensions.overlays.default
          colmena.overlay
        ];
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

        "fw" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = specialArgs // {
            host = "fw";
          };
          modules = [
            ./host/fw
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
        devShells = import ./devshells { inherit pkgs; } // {
          default = pkgs.mkShell {
            buildInputs = [
              colmena.packages.${system}.colmena
              agenix.packages.${system}.default
              pkgs.openssl
            ];
          };
        };
        formatter = pkgs.nixfmt-tree;
      }
    );
}
