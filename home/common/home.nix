{ config, pkgs, ... }:

{
  # Home Manager configuration
  # This manages user-specific configuration and packages
  
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.11";

  # User packages
  home.packages = with pkgs; [];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
