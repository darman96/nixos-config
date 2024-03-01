{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/hyprland";
    
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
    };

    ags.url = "github:Aylur/ags";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      inherit (nixpkgs) lib;
    in
    {
    
      nixosConfigurations =
      let
        hosts = lib.filterAttrs
          (dir: type: type == "directory" && builtins.pathExists (./hosts/${dir}/default.nix))
          (builtins.readDir ./hosts);
      in
      lib.mapAttrs (host: _: lib.nixosSystem {
        system = system;

        specialArgs = { inherit host; inherit inputs; };

        modules = [
          ./modules/nixos/base.nix
          ./hosts/${host}/default.nix
          home-manager.nixosModule
        ];
      }) hosts;

    };
}
