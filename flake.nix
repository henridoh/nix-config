{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs_25-05.url = "github:NixOS/nixpkgs/nixos-25.05";
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
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
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
      nixpkgs_25-05,
      nixpkgs,
      simple-nixos-mailserver,
      vscode-extensions,
    }@inputs:
    let
      inherit (nixpkgs) lib;
      var = import ./var { inherit lib; };
      lib' = import ./lib.nix { inherit lib var; };

      pkgs_25-05 = import nixpkgs_25-05 { system = "x86_64-linux"; };
      mypkgs = self.packages.x86_64-linux;

      specialArgs = rec {
        inherit
          inputs
          lib'
          pkgs_25-05
          mypkgs
          var
          ;
        secrets = lib'.walk-dir ./secrets;
      };

      mkModule =
        {
          entry,
          isServer ? false,
        }:
        {
          imports = [
            entry
            ./mod
          ]
          ++ (if isServer then [ ] else [ ./home ]);
        };

      # Not exposed as flake outputs because they depend on specialArgs
      # if you add a host, make sure to add it to var/default.nix as well
      nixosModules = {
        "solo" = mkModule { entry = ./host/solo; };
        "c2" = mkModule { entry = ./host/c2; };
        "fw" = mkModule { entry = ./host/fw; };
        "roam" = mkModule {
          entry = ./host/roam;
          isServer = true;
        };
      };

    in
    {
      nixosConfigurations =
        let
          mkDesktop = host: {
            name = host;
            value = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              inherit specialArgs;
              modules = [ (nixosModules.${host}) ];
            };
          };
        in
        lib.listToAttrs (
          map mkDesktop [
            "solo"
            "c2"
            "fw"
          ]
        )
        // {
          "test-vm" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = [
              {
                imports = [
                  ./mod
                  ./host/test-vm
                ];
              }
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
          imports = [ nixosModules."roam" ];
        };
        "solo" = {
          deployment.targetHost = null;
          deployment.allowLocalDeployment = true;
          imports = [ nixosModules."solo" ];
        };
        "c2" = {
          deployment.targetHost = null;
          deployment.allowLocalDeployment = true;
          imports = [ nixosModules."c2" ];
        };
        "fw" = {
          deployment.targetHost = null;
          deployment.allowLocalDeployment = true;
          imports = [ nixosModules."fw" ];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells = import ./devshells { inherit pkgs; } // {
          default = pkgs.mkShell {
            buildInputs = [
              colmena.packages.${system}.colmena
              agenix.packages.${system}.default
              pkgs.openssl
              pkgs.jq
              pkgs.syncthing
            ];
          };
        };
        formatter = pkgs.nixfmt-tree;
        packages = import ./packages { inherit inputs system; };
      }
    );
}
