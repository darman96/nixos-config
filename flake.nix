{
  description = "NixOS configuration with support for multiple hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let 
    lib = nixpkgs.lib;
    
    findHosts = dir:
      lib.pipe dir [
        builtins.readDir
        (lib.mapAttrsToList (name: type:
          if type == "directory" then
            let
              configPath = dir + "/${name}/configuration.nix";
            in
            if builtins.pathExists configPath then
              [ { inherit name; path = configPath; } ]
            else []
          else []
        ))
        lib.flatten      
      ];
    
  in {
    # NixOS configurations
    nixosConfigurations = {
      # Desktop configuration
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix
          ./modules/nixos/common.nix
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user = import ./home/common/home.nix;
          }
        ];
      };

      # Laptop configuration
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop/configuration.nix
          ./modules/nixos/common.nix
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user = import ./home/common/home.nix;
          }
        ];
      };
    };
  };
}
