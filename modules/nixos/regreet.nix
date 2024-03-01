{ lib, config, pkgs, ... }:

{
  programs.regreet.enable = true;
  programs.regreet.cageArgs = [ "-s" "-m" "last" ];
}