{ config, pkgs, ... }:

{
  imports = [
    ./../../modules/home-manager/hyprland.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "darman";
  home.homeDirectory = "/home/darman";

  monitors = [
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      x = 1920;
      y = 0;
      refreshRate = 144;
      enabled = true;
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      x = 0;
      y = 500;
      refreshRate = 60;
      enabled = true;
    }
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    alacritty
    vivaldi
    vivaldi-ffmpeg-codecs
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  home.file = {

  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
