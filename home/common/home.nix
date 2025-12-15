{ config, pkgs, ... }:

{
  # Home Manager configuration
  # This manages user-specific configuration and packages
  
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "user";
  home.homeDirectory = "/home/user";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # User packages
  home.packages = with pkgs; [
    # CLI tools
    ripgrep
    fd
    bat
    exa
    fzf
    jq
    
    # Development
    neovim
    
    # Terminal
    alacritty
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # Bash configuration
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      grep = "grep --color=auto";
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
