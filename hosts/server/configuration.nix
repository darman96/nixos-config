{ config, pkgs, ... }:

{
  # server configuration
  
  # Hostname
  networking.hostName = "nixos-server";

  # Hardware configuration
  imports = [
    ./hardware-configuration.nix
  ];

  # Host-specific packages
  environment.systemPackages = with pkgs; [];

  # Define a user account
  users.users.user = {
    isNormalUser = true;
    description = "server User";
    extraGroups = [ "networkmanager" "wheel" ];
    # Set password with: passwd user
    # Or use hashedPassword option
  };

  # Firewall configuration (adjust as needed)
  # networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  # networking.firewall.allowedUDPPorts = [ ];
}
