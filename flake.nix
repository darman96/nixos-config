{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (nixpkgs) lib;
  in
  {

    nixosConfigurations = 
    let
      modules = [
        home-manager.nixosModule
        ./modules/nixos/base.nix
      ];

      hosts = lib.filterAttrs
        (dir_entry: type: type == "directory" && builtins.pathExists(./hosts + "/${dir_entry}/configuration.nix"))
        (builtins.readDir ./hosts);
    in 
    lib.mapAttrs(host: _: lib.nixosSystem {
      system = "x86_64-linux";

      modules = modules ++ [
        ./hosts/${host}/configuration.nix
      ];

      specialArgs = { inherit host; inherit inputs; };
    })
    hosts;
  };
}
