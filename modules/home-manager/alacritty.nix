{ lib, config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env.SHELL = "${pkgs.zsh}/bin/zsh";
      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = ["-l"];
      };
      window.padding = { x = 20; y = 10; };
      font = {
        normal = { family = "FiraCode NerdFont Mono"; style = "Regular"; }; 
      };
    };
  };
}