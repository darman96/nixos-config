# Common Tasks and Troubleshooting

## Daily Operations

### Updating the system

```bash
# Update flake inputs to get latest packages
cd ~/nixos-config
nix flake update

# Rebuild with updated packages
sudo nixos-rebuild switch --flake .#desktop
```

### Installing a new package

**System-wide package** (in `hosts/desktop/configuration.nix`):
```nix
environment.systemPackages = with pkgs; [
  # Add your package here
  firefox
  htop
];
```

**User package** (in `home/common/home.nix`):
```nix
home.packages = with pkgs; [
  # Add your package here
  ripgrep
  fzf
];
```

Then rebuild:
```bash
sudo nixos-rebuild switch --flake .#desktop
```

### Rolling back changes

```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Switch to a specific generation
sudo nixos-rebuild switch --switch-generation 42
```

### Cleaning up old generations

```bash
# Delete generations older than 7 days
sudo nix-collect-garbage --delete-older-than 7d

# Delete all old generations (keep only current)
sudo nix-collect-garbage -d

# Optimize nix store
sudo nix-store --optimize
```

## Configuration Changes

### Adding a new user

In your host configuration:
```nix
users.users.newuser = {
  isNormalUser = true;
  description = "New User";
  extraGroups = [ "networkmanager" "wheel" ];
  initialPassword = "changeme";  # Change on first login
};
```

### Enabling a service

```nix
# Example: Enable PostgreSQL
services.postgresql = {
  enable = true;
  package = pkgs.postgresql_15;
  enableTCPIP = true;
  authentication = ''
    local all all trust
    host all all 127.0.0.1/32 trust
  '';
};
```

### Changing the desktop environment

In `hosts/desktop/configuration.nix`:

```nix
# For GNOME
services.xserver = {
  enable = true;
  displayManager.gdm.enable = true;
  desktopManager.gnome.enable = true;
};

# For KDE Plasma
services.xserver = {
  enable = true;
  displayManager.sddm.enable = true;
  desktopManager.plasma5.enable = true;
};

# For XFCE
services.xserver = {
  enable = true;
  displayManager.lightdm.enable = true;
  desktopManager.xfce.enable = true;
};
```

## Troubleshooting

### Build fails with "hash mismatch"

```bash
# Clear the Nix store cache
nix-store --verify --check-contents --repair

# Update flake lock
nix flake update
```

### Running out of disk space

```bash
# Check disk usage
df -h /nix

# Clean up old generations
sudo nix-collect-garbage -d

# Optimize store
sudo nix-store --optimize

# Check what's using space
du -sh /nix/store/* | sort -h | tail -20
```

### System won't boot after update

1. Select previous generation from bootloader menu
2. Boot into working system
3. Roll back: `sudo nixos-rebuild switch --rollback`
4. Investigate what went wrong in the configuration

### "Permission denied" errors

```bash
# Make sure you're using sudo for system operations
sudo nixos-rebuild switch --flake .#desktop

# Check file ownership
ls -la ~/nixos-config

# Fix ownership if needed
sudo chown -R $USER:$USER ~/nixos-config
```

### Hardware not working (WiFi, GPU, etc.)

1. Check if required kernel modules are loaded:
   ```bash
   lsmod | grep -i wifi
   ```

2. Add firmware packages in configuration:
   ```nix
   hardware.enableRedistributableFirmware = true;
   hardware.enableAllFirmware = true;
   ```

3. For specific hardware, check NixOS hardware database:
   - https://github.com/NixOS/nixos-hardware

### Flake evaluation errors

```bash
# Check flake syntax
nix flake check

# Show detailed error messages
nix eval .#nixosConfigurations.desktop.config.system.build.toplevel --show-trace

# Validate a specific file
nix-instantiate --parse filename.nix
```

## Testing Changes Safely

### Test without making default

```bash
# Build and activate, but don't set as default boot option
sudo nixos-rebuild test --flake .#desktop

# If something breaks, just reboot to get back to previous config
```

### Test in a VM

```bash
# Build a VM from your configuration
nixos-rebuild build-vm --flake .#desktop

# Run the VM
./result/bin/run-nixos-vm

# Clean up
rm -rf nixos.qcow2 result
```

### Dry run to see what would change

```bash
# See what would be rebuilt
nixos-rebuild dry-build --flake .#desktop

# See what would be activated
nixos-rebuild dry-activate --flake .#desktop
```

## Getting Help

- NixOS Manual: https://nixos.org/manual/nixos/stable/
- NixOS Wiki: https://nixos.wiki/
- NixOS Discourse: https://discourse.nixos.org/
- NixOS Matrix/IRC: #nixos on Matrix/Libera.Chat
- Search packages: https://search.nixos.org/packages
- Search options: https://search.nixos.org/options
