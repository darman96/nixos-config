{ config, pkgs, inputs, ... }:

{
  imports = [
    ./../../modules/home-manager/hyprland.nix
    inputs.ags.homeManagerModules.default
  ];
  
  # ░█▒█░▄▀▀▒██▀▒█▀▄
  # ░▀▄█▒▄██░█▄▄░█▀▄

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

  # ▒█▀▄▒▄▀▄░▄▀▀░█▄▀▒▄▀▄░▄▀▒▒██▀░▄▀▀
  # ░█▀▒░█▀█░▀▄▄░█▒█░█▀█░▀▄█░█▄▄▒▄██
  
  home.packages = with pkgs; [
    alacritty
    vivaldi
    vivaldi-ffmpeg-codecs
    playerctl
    pamixer
    gh
    vscode
    keepassxc
    discord

    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # ░▄▀▀░█▄█▒██▀░█▒░░█▒░
  # ▒▄██▒█▒█░█▄▄▒█▄▄▒█▄▄

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      "??" = "gh copilot suggest";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "amuse";
    };
  };

  # ▒██▀░█▄░█░█▒█░█▒█▀▄░▄▀▄░█▄░█░█▄▒▄█▒██▀░█▄░█░▀█▀
  # ░█▄▄░█▒▀█░▀▄▀░█░█▀▄░▀▄▀░█▒▀█░█▒▀▒█░█▄▄░█▒▀█░▒█▒
  
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # ░█▄▒▄█░█░▄▀▀░▄▀▀
  # ░█▒▀▒█░█▒▄██░▀▄▄

  programs.ags = {
    enable = true;
  };

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
