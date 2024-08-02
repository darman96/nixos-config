{ lib, config, pkgs, ... }:

{
  imports = [ ./monitors.nix ];

  home.file.".config/hypr/hyprland.conf".source = ./files/hyprland.conf;
  home.file.".config/hypr/autostart.conf".source = ./files/autostart.conf;
  home.file.".config/hypr/environment.conf".source = ./files/environment.conf;
  home.file.".config/hypr/keybinds.conf".source = ./files/keybinds.conf;
  home.file.".config/hypr/windowrules.conf".source = ./files/windowrules.conf;
  home.file.".config/hypr/hyprpaper.conf".source = ./files/hyprpaper.conf;
}