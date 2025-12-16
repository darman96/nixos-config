{ config, pkgs, ... }:

{
  # Common system configuration shared across all hosts
  
  # Boot loader configuration
  boot.loader = {
    systemd-boot.enable = true;
  };

  # Networking
  networking.networkmanager.enable = true;

  # Localisation
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # Common system packages
  environment.systemPackages = with pkgs; [
    # System utilities
    nano
    wget
    curl
    git
    htop
    btop
    
    # File management
    tree
    unzip
    zip
  ];

  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Default shell
  programs.zsh = {
    enable = true;
    enableCompletions = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "ls -l";
      la = "ls -a";
      update = "sudo nixos-rebuild switch";
    };
    
    history.size = 10000;
  };

  # System state version
  system.stateVersion = "25.11";
}
