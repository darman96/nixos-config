# Example: Adding a new host configuration

This guide shows how to add a new host (e.g., "server") to your NixOS configuration.

## Step 1: Create host directory

```bash
mkdir -p hosts/server
```

## Step 2: Generate hardware configuration

On the target machine, run:
```bash
nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

Then copy it to `hosts/server/hardware-configuration.nix`

## Step 3: Create configuration.nix

Create `hosts/server/configuration.nix`:

```nix
{ config, pkgs, ... }:

{
  # Server-specific configuration
  
  # Hostname
  networking.hostName = "nixos-server";

  # Hardware configuration
  imports = [
    ./hardware-configuration.nix
  ];

  # Server doesn't need a desktop environment
  # Enable SSH for remote access (already enabled in common.nix)
  
  # Server-specific packages
  environment.systemPackages = with pkgs; [
    # Server tools
    nginx
    postgresql
    
    # Monitoring
    htop
    iotop
    nethogs
  ];

  # Enable nginx
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  # Enable PostgreSQL
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
  };

  # Define a user account
  users.users.admin = {
    isNormalUser = true;
    description = "Server Admin";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      # Add your SSH public keys here
      # "ssh-ed25519 AAAAC3... user@host"
    ];
  };

  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };
}
```

## Step 4: Add to flake.nix

Edit `flake.nix` and add the new host to `nixosConfigurations`:

```nix
nixosConfigurations = {
  # ... existing configurations (desktop, laptop)
  
  server = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./hosts/server/configuration.nix
      ./modules/nixos/common.nix
      
      # Optional: you might not need home-manager on a server
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.admin = import ./home/common/home.nix;
      }
    ];
  };
};
```

## Step 5: Build and deploy

```bash
# Build the configuration
nixos-rebuild build --flake .#server

# Deploy to the server (from the server itself)
sudo nixos-rebuild switch --flake .#server

# Or deploy remotely (if you have SSH access)
nixos-rebuild switch --flake .#server --target-host admin@server-ip --use-remote-sudo
```

## Tips

- Keep common configuration in `modules/nixos/common.nix`
- Create additional modules for shared functionality (e.g., `modules/nixos/webserver.nix`)
- Use host-specific configuration files for unique settings
- Consider creating separate home-manager profiles for different user types
