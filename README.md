# NixOS Configuration

A multi-host NixOS configuration using Flakes and Home Manager, structured following best practices.

## Structure

```
.
├── flake.nix                 # Main flake configuration
├── hosts/                    # Host-specific configurations
│   ├── desktop/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── laptop/
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/                  # Shared NixOS modules
│   └── nixos/
│       └── common.nix        # Common system configuration
├── home/                     # Home Manager configurations
│   └── common/
│       └── home.nix          # Common user configuration
```

## Features

- **Multi-host support**: Separate configurations for different machines (desktop, laptop)
- **Flakes-based**: Modern, reproducible NixOS configuration
- **Home Manager integration**: User environment management
- **Modular structure**: Shared common configuration with host-specific overrides
- **Best practices**: Follows NixOS community conventions
- **Automation tools**: Script to quickly add new hosts (`add-host.sh`)

## Installation

### Fresh Installation

1. Boot from NixOS installation media
2. Partition your disk and mount filesystems
3. Generate hardware configuration:
   ```bash
   nixos-generate-config --root /mnt
   ```
4. Clone this repository:
   ```bash
   git clone https://github.com/darman96/nixos-config.git /mnt/etc/nixos
   cd /mnt/etc/nixos
   ```
5. Copy the generated hardware configuration to your host:
   ```bash
   cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/desktop/
   # or for laptop:
   # cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/laptop/
   ```
6. Edit the configuration as needed (hostname, users, etc.)
7. Install NixOS:
   ```bash
   nixos-install --flake /mnt/etc/nixos#desktop
   # or for laptop:
   # nixos-install --flake /mnt/etc/nixos#laptop
   ```

### Existing Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/darman96/nixos-config.git ~/nixos-config
   cd ~/nixos-config
   ```
2. Copy your current hardware configuration:
   ```bash
   sudo cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/desktop/
   # or for laptop:
   # sudo cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/laptop/
   ```
3. Review and customize the configuration
4. Build and switch:
   ```bash
   sudo nixos-rebuild switch --flake .#desktop
   # or for laptop:
   # sudo nixos-rebuild switch --flake .#laptop
   ```

## Usage

### Building the configuration

```bash
# Build without activating
nixos-rebuild build --flake .#desktop

# Build and activate
sudo nixos-rebuild switch --flake .#desktop

# Build and test (doesn't set as default boot option)
sudo nixos-rebuild test --flake .#desktop
```

### Updating the system

```bash
# Update flake inputs
nix flake update

# Rebuild with updated inputs
sudo nixos-rebuild switch --flake .#desktop
```

## Customization

### Adding a new host

Use the provided `add-host.sh` script to automatically create a new host configuration:

```bash
./add-host.sh <hostname>
```

This will:
- Create a new host directory with template configuration files
- Automatically add the host to `flake.nix`
- Display next steps for customization

**Manual method:**

1. Create a new directory under `hosts/`:
   ```bash
   mkdir -p hosts/newhost
   ```
2. Create `configuration.nix` and `hardware-configuration.nix`
3. Add the host to `flake.nix`:
   ```nix
   nixosConfigurations.newhost = nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     modules = [
       ./hosts/newhost/configuration.nix
       ./modules/nixos/common.nix
       # ... other modules
     ];
   };
   ```

### Modifying user configuration

Edit `home/common/home.nix` to change user-specific settings, packages, and dotfiles.

### Adding shared modules

Create new modules in `modules/nixos/` and import them in your host configurations or `flake.nix`.

## License

MIT License - See LICENSE file for details
