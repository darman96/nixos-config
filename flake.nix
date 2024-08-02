{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
  let
    user_name = "darman";
    full_name = "Erik Simon";

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
      specialArgs = {
        inherit inputs;
        inherit host;
        inherit user_name;
        inherit full_name;
      };

      modules = [
        ./modules/nixos/base.nix
        ./hosts/${host}/default.nix
      ];
    }) hosts;
  };
}
