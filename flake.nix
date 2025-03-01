{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs } @ inputs: 
    let lib = nixpkgs.lib; in 
    let mod = import ./mod { inherit lib; }; in
    let specialArgs = { inherit inputs mod; }; in
    {
      nixosConfigurations = {
        "solo" = nixpkgs.lib.nixosSystem
        {
          system = "x86_64-linux";
          inherit specialArgs;
          modules = [ ./host/solo ];
        };

        "c2" = nixpkgs.lib.nixosSystem
        {
          system = "x86_64-linux";
          inherit specialArgs;
          modules = [ ./host/c2 ];
        };
      };
    };
}
