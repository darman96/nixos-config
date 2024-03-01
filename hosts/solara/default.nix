# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, host, pkgs, inputs, ... }:

{

  # ░█░█▄▒▄█▒█▀▄░▄▀▄▒█▀▄░▀█▀░▄▀▀
  # ░█░█▒▀▒█░█▀▒░▀▄▀░█▀▄░▒█▒▒▄██

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./../../modules/nixos/tuigreet.nix
      ./../../modules/nixos/regreet.nix
      ./../../modules/nixos/kde-plasma.nix
    ];

  fileSystems."/mnt/ssd_01" = {
    device = "/dev/disk/by-uuid/69798b68-efdf-46bc-8762-ce9c2b2c1267";
    fsType = "ext4";
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  programs.steam = {
    enable = true;
  };

  # ░█▄█░▄▀▄░▄▀▀░▀█▀
  # ▒█▒█░▀▄▀▒▄██░▒█▒

  networking.hostName = host; # Define your hostname.

  # ░█▒█░▄▀▀▒██▀▒█▀▄░▄▀▀
  # ░▀▄█▒▄██░█▄▄░█▀▄▒▄██

  users.users.darman = {
    isNormalUser = true;
    description = "Erik Simon";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users = { "darman" = import ./home.nix; };
  };

  # ░▄▀▀░▀▄▀░▄▀▀░▀█▀▒██▀░█▄▒▄█░░▒█▀▄▒▄▀▄░▄▀▀░█▄▀▒▄▀▄░▄▀▒▒██▀░▄▀▀
  # ▒▄██░▒█▒▒▄██░▒█▒░█▄▄░█▒▀▒█▒░░█▀▒░█▀█░▀▄▄░█▒█░█▀█░▀▄█░█▄▄▒▄██

  environment.systemPackages = with pkgs; [
    wget
    git
  ];

  # ░█▄▒▄█░█░▄▀▀░▄▀▀
  # ░█▒▀▒█░█▒▄██░▀▄▄

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
