{ lib, config, pkgs, ... }:

{

  # ░█▄░█░█░▀▄▀░░░▄▀▀▒██▀░▀█▀░▀█▀░█░█▄░█░▄▀▒░▄▀▀
  # ░█▒▀█░█░█▒█▒░▒▄██░█▄▄░▒█▒░▒█▒░█░█▒▀█░▀▄█▒▄██

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "@wheel" ];
  nixpkgs.config.allowUnfree = true;

  # ░██▄░▄▀▄░▄▀▄░▀█▀░█▒░░▄▀▄▒▄▀▄░█▀▄▒██▀▒█▀▄
  # ▒█▄█░▀▄▀░▀▄▀░▒█▒▒█▄▄░▀▄▀░█▀█▒█▄▀░█▄▄░█▀▄

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.extraConfig = ''
    video=HDMI-A-1:d
  '';

  # ░█▄░█▒██▀░▀█▀░█░░▒█░▄▀▄▒█▀▄░█▄▀░█░█▄░█░▄▀▒
  # ░█▒▀█░█▄▄░▒█▒░▀▄▀▄▀░▀▄▀░█▀▄░█▒█░█░█▒▀█░▀▄█

  networking.networkmanager.enable = true;

  # ░█▒░░▄▀▄░▄▀▀▒▄▀▄░█▒░▒██▀
  # ▒█▄▄░▀▄▀░▀▄▄░█▀█▒█▄▄░█▄▄

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  console.keyMap = "de";

  # ▒▄▀▄░█▒█░█▀▄░█░▄▀▄
  # ░█▀█░▀▄█▒█▄▀░█░▀▄▀

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # ▒█▀▄▒█▀▄░█░█▄░█░▀█▀░█░█▄░█░▄▀▒
  # ░█▀▒░█▀▄░█░█▒▀█░▒█▒░█░█▒▀█░▀▄█

  services.printing.enable = true;

}