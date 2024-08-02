{ config, host, user_name, full_name, pkgs, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
    ./hardware-configuration.nix
    ./../../modules/nixos/hyprland.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  users.users.${user_name} = {
    isNormalUser = true;
    description = full_name;
    extraGroups = [ "networkmanager" "wheel" ];
    password = "123456";
    packages = with pkgs; [
      vscode
    ];
  };

  home-manager = {
    extraSpecialArgs = { 
      inherit inputs;
      inherit user_name;
    };
    users = {
      "${user_name}" = import ./home.nix;  
    };

    useGlobalPkgs = true;
    useUserPackages = true;
  };

  programs.firefox.enable = true;
  programs.steam.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
