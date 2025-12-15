# Creating and Using Custom Modules

This guide explains how to create and use custom NixOS modules in your configuration.

## Why use modules?

Modules help you:
- Organize configuration logically
- Reuse configuration across multiple hosts
- Enable/disable features easily
- Share configuration with others

## Creating a simple module

Let's create a module for a development environment.

### Step 1: Create the module file

Create `modules/nixos/development.nix`:

```nix
{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    custom.development.enable = mkEnableOption "development environment";
    
    custom.development.languages = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Programming languages to install";
    };
  };

  config = mkIf config.custom.development.enable {
    environment.systemPackages = with pkgs; [
      # Version control
      git
      git-lfs
      
      # Editors
      vim
      neovim
      vscode
      
      # Build tools
      gnumake
      cmake
      
      # Containers
      docker
      docker-compose
    ] ++ (optionals (elem "python" config.custom.development.languages) [
      python311
      python311Packages.pip
      python311Packages.virtualenv
    ]) ++ (optionals (elem "nodejs" config.custom.development.languages) [
      nodejs_20
      nodePackages.npm
      nodePackages.yarn
    ]) ++ (optionals (elem "rust" config.custom.development.languages) [
      rustc
      cargo
      rustfmt
      clippy
    ]) ++ (optionals (elem "go" config.custom.development.languages) [
      go
      gopls
      golangci-lint
    ]);
    
    # Enable Docker if development is enabled
    virtualisation.docker.enable = true;
    
    # Add user to docker group
    users.users.user.extraGroups = [ "docker" ];
  };
}
```

### Step 2: Import the module

In your host configuration (e.g., `hosts/desktop/configuration.nix`), add:

```nix
{
  imports = [
    # ... other imports
  ];
  
  # Enable and configure the development module
  custom.development = {
    enable = true;
    languages = [ "python" "nodejs" "rust" ];
  };
}
```

Or add it to `flake.nix` to make it available to all hosts:

```nix
nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hosts/desktop/configuration.nix
    ./modules/nixos/common.nix
    ./modules/nixos/development.nix  # Add this line
    # ... other modules
  ];
};
```

## Example: Creating a gaming module

Create `modules/nixos/gaming.nix`:

```nix
{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    custom.gaming.enable = mkEnableOption "gaming environment";
  };

  config = mkIf config.custom.gaming.enable {
    # Gaming-specific packages
    environment.systemPackages = with pkgs; [
      steam
      lutris
      wine
      winetricks
      gamemode
      mangohud
    ];
    
    # Enable Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    
    # Enable gamemode
    programs.gamemode.enable = true;
    
    # 32-bit graphics support
    hardware.opengl.driSupport32Bit = true;
    
    # Kernel parameters for gaming
    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
  };
}
```

## Module organization best practices

```
modules/
├── nixos/
│   ├── common.nix          # Base system configuration
│   ├── desktop.nix         # Desktop environment settings
│   ├── development.nix     # Development tools
│   ├── gaming.nix          # Gaming setup
│   ├── server.nix          # Server configuration
│   └── security.nix        # Security hardening
└── home-manager/
    ├── common.nix          # Common user settings
    ├── terminal.nix        # Terminal configuration
    └── editors.nix         # Editor configuration
```

## Using modules in flake.nix

```nix
outputs = { self, nixpkgs, home-manager, ... }@inputs: {
  nixosConfigurations = {
    desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/desktop/configuration.nix
        ./modules/nixos/common.nix
        ./modules/nixos/desktop.nix
        ./modules/nixos/development.nix
        ./modules/nixos/gaming.nix
        # ... other modules
      ];
    };
    
    laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/laptop/configuration.nix
        ./modules/nixos/common.nix
        ./modules/nixos/desktop.nix
        ./modules/nixos/development.nix
        # Note: no gaming module for laptop
      ];
    };
  };
};
```

## Tips

- Use `mkEnableOption` for simple on/off features
- Use `mkOption` for configurable parameters
- Use `mkIf` to conditionally apply configuration
- Test your modules on a VM before deploying to production
- Document your module options clearly
- Keep modules focused on a single purpose
