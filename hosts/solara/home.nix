{ config, pkgs, inputs, user_name, ... }:

{
  imports = [
    ./../../modules/home-manager/hyprland/default.nix
    ./../../modules/home-manager/alacritty.nix
  ];

  home.username = user_name;
  home.homeDirectory = "/home/${user_name}";

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
  
  gtk.theme.package = pkgs.nightfox-gtk-theme;

  home.packages = with pkgs; [
    playerctl
    pamixer
    protonplus
    vivaldi
    keepassxc

    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
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
  
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
