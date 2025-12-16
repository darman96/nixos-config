# Setup Instructions

Since this repository uses Nix Flakes, you need to generate the `flake.lock` file on a system with Nix installed.

## First-time setup

On a NixOS system or a system with Nix installed with flakes enabled:

```bash
# Navigate to the repository
cd nixos-config

# Generate flake.lock
nix flake update

# Check that flakes are valid
nix flake check

# Try building a configuration
nix build .#nixosConfigurations.desktop.config.system.build.toplevel
```

## Note

The `flake.lock` file will be generated automatically when you:
- Run `nix flake update`
- Build the configuration with `nixos-rebuild`
- Or any other nix flake command

This file pins the exact versions of all dependencies for reproducibility.
