{ lib, config, pkgs, inputs, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = false;
  services.xserver.desktopManager.plasma5.enable = true;
}